clear, clc
syms s
F = 3;
G = s + 3 + 15/s;
H = 1 / (s + 3);

T = simplify((-1)/(1 + H*G))
[N, D] = numden(T); stab = roots(double(flip(coeffs(D))))