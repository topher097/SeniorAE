clear, clc

syms s
F = 5;
G = 3*s + 1 + 13/s;
H = 1 / (s+9);

T = simplify((H) / (1 + G*H))

[N,D] = numden(T); stability = roots(double(flip(coeffs(D))))