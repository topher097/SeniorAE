clear, clc
%% Insert provided data:
syms s
F = input('F = ');
G = input('G = ');
H = input('H = ');
%% Calculations:
T = simplify(F / (1 + H*G))

%stability = roots(denominator)