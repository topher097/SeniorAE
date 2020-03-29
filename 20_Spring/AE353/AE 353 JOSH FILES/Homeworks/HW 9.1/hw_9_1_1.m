clear, clc
%% Insert pertinent data:
tau = input('Tau: ');
syms s
%% Calculations
tDelay = exp(-s*tau)
tApprox = (2 - s*tau) / (2 + s*tau)