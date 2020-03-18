clear, clc
%% Data
syms s
F = 3;
G = 5*s + 3 + 3/s;
H = (3*s - 4) / (s^2 + 6);
%% Calculations
T = simplify((-1) / (1-G*H))
[N, D] = numden(T);
denom = double(flip(coeffs(D)));
stab = vpa(roots(flip(denom)),2)