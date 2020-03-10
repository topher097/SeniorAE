clear, clc

syms s
F = 3;
G = s + 5 + 7/s;
H = 1/s;

T = simplify((-1) / (1 + H*G))

[N, D] = numden(T); denom = roots(double(flip(coeffs(D))))