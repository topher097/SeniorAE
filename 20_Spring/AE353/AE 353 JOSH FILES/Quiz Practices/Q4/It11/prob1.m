clear, clc

syms s
F = 2;
G = 4*s + 2 + 13/s;
H = 1 / (s + 2);

T = simplify((F*G*H) / (1 + H*G))

[N, D] = numden(T); stab = roots(flip(coeffs(D)))