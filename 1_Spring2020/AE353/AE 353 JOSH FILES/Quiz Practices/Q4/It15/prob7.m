clear, clc

syms s
F = 4;
G = 5*s + 2 + 8/s;
H = 1 / (s-5);

T = simplify((1) / (1 + H*G))

[N, D] = numden(T); stab = roots(double(flip(coeffs(D))))