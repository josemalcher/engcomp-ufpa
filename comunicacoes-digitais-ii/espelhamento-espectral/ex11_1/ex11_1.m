% MATLAB PROGRAM <Ex11 1.m>
% Este programa efetua a simula��ode sinaliza��o FHSS com
% detec��o n�o coerente de FSK.
% O sinal interferente bloquear� 1 das L bandas de frequ�ncias e
% pode ser ligado ou desligado fornecendo o valor de entrada janning = l ou
% Detec��o MFSK n�o coerente 0
% requer apenas a compara��o das magnitudes dos bin de frequ�ncia

clear; clf;
n = 10000; % N�mero de s�mbolos de dados na simula��o
L = 8;     % N�mero de bandas de frequ�ncias
Lh = 1;    % N�mero de saltos por s�mbolo (bit)
m = 1;     % N�mero de usu�rios

% Gera��o dos bits de informa��o
s_data = round(rand(n, m));

% Liga ou desliga a interfer�ncia parcial
jamming = input('Interferencia=? (Entre 1 para Sim, 0 para Nao)');

% Gera��o de fases aleat�rias nas duas frequ�ncias
xbase1 = [exp(j*2*pi*rand(Lh*n,1))];
xbase0 = [exp(j*2*pi*rand(Lh*n,1))];

% Modula��o de duas frequ�ncias ortogonais
xmodsig = [kron(s_data, ones(Lh,1)).*xbase1 kron((1-s_data), ones(Lh, 1)).*xbase0];
clear xbase0 xbase1;

% Gera��o de uma sequ�ncia aleat�ria de saltos de comprimento nLh
Phop=round(rand (Lh*n, 1) * (L-1) ) +1; % Padr�o PN de saltos
Xsiga=sparse (1 : Lh*n, Phop, xmodsig ( : , 1));
Xsigb=sparse (1 : Lh*n, Phop, xmodsig ( : , 2));

% Gera��o de sequ�ncias de ru�do para os dois canais de frequ�ncia
noisel=randn(Lh*n, 1) +j *randn(Lh*n, 1);
noise2=randn(Lh*n, 1) +j *randn(Lh*n, 1);
Nsiga=sparse (1 : Lh*n, Phop, noisel);
Nsigb=sparse (1 : Lh*n, Phop, noise2);
clear noisel noise2 xmodsig;
BER=[];
BER_az=[];

% Adiciona um canal a sofrer interfer�ncia (escolha aleat�ria)
if (jamming)
  nch=round(rand*(L-1)) + 1;
  Xsiga(:,nch)=Xsiga(:,nch)*0;
  Xsigb(:,nch)=Xsigb(:,nch)*0;
  Nsiga(:,nch)=Nsiga(:,nch)*0;
  Nsigb(:,nch)=Nsigb(:,nch)*0;
end

% Gera��o do ru�do de canal (AWGN)
for i=1:10,
  Eb2N(i)=i;                 % (Eb/N em dB)
  Eb2N_num=10^(Eb2N(i)/10);  % Eb/N num�rico
  Var_n=1/(2*Eb2N_num);      % 1/SNR � a vari�ncia de ru�do
  signois=sqrt(Var_n);       % desvio?padr�o
  ych1=Xsiga+signois*Nsiga;  % Canais completos AWGN
  ych2=Xsigb+signois*Nsigb;  % Canais ARGN
  
  % Non-coherent detection
  for kk=0:n-1
    Yvec1=[];Yvec2=[];
    for kk2=1:Lh,
      Yvec1=[Yvec1 ych1(kk*Lh+kk2, Phop(kk*Lh+kk2))];
      Yvec2=[Yvec2 ych2(kk*Lh+kk2, Phop(kk*Lh+kk2))];
    end
    ydim1=Yvec1*Yvec1';
    ydim2=Yvec2*Yvec2';
    dec(kk+1)=(ydim1>ydim2);
  end
  clear ych1 ych2;
  % C�lculo da BER das simula��es
  BER=[BER; sum(dec'~=s_data)/n];
  % Compara com a BER anal�tica
  BER_az=[BER_az; 0.5*exp(-Eb2N_num/2)];
end
figber=semilogy(Eb2N, BER_az, 'k-', Eb2N, BER, 'k-o');
set(figber, 'Linewidth', 2);
legend('BER analitica', 'Simulacao FHSS');
fx=xlabel('E_b/B (dB');
fy=ylabel('Taxa de erro de bit');
set(fx,'FontSize', 11); set(fy, 'FontSize', 11);