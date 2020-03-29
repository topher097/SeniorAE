clear, clc

syms s

F = 4;
G = 4*s + 2 + 5/s;
H = (s + 1) / (s^2 + 14);

T = simplify((-G) / (1 + H * G))

[N, D] = numden(T); stability = roots(double(flip(coeffs(D))))