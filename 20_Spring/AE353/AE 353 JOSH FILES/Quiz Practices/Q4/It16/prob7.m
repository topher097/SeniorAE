clear, clc

syms s
F = 4;
G = 4 + 2/s;
H = 1 / (s+6);

T = simplify((F) / (1 + G*H))

[N,D] = numden(T); stab = roots(double(flip(coeffs(D))))