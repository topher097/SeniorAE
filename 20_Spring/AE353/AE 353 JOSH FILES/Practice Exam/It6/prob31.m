clear, clc

syms s
F = 2;
G = 3*s + 3 + 2/s;
H = (s + 1) / (s^2 - 13);

T = simplify((F*G*H) / (1 + G*H))

[N,D] = numden(T); stability = roots(double(flip(coeffs(D))))