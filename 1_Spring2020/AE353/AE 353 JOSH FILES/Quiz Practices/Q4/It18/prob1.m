clear, clc

syms s
F = 4;
G = 5*s + 1 + 7/s;
H = (2*s - 2) / (s^2 + 17);

T = simplify((-1) / (1 + G*H))

[N,D] = numden(T); stability = roots(double(flip(coeffs(D))))