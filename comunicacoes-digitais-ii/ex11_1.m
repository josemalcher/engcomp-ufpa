% MATLAB PROGRAM <Ex11 1.m>
% Este programa efetua a simula��ode sinaliza��o FHSS com
% detec��o n�o coerente de FSK.
% O sinal interferente bloquear� 1 das L bandas de frequ�ncias e
% pode ser ligado ou desligado fornecendo o valor de entrada janning=l ou
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
jamming = input('interfer�ncia=? (Entre 1 para Sim, 0 para N�o)');

% Gera��o de fases aleat�rias nas duas frequ�ncias
xbase1 = [exp(j*2*pi*rand(Lh*n,1))];
xbase0 = [exp(j*2*pi*rand(Lh*n,1))];

% Modula��o de duas frequ�ncias ortogonais