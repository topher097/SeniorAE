clear, clc

syms s
F = 4;
G = 3*s + 3 + 12/s;
H = 1 / (s-8);

T = simplify((-H*G) / (1 + H*G))

[N,D] = numden(T); stab = roots(double(flip(coeffs(D))))