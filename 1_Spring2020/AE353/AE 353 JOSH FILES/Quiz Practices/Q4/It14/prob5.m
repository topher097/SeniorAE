clear, clc

syms s
F = 5;
G = s + 5 + 6/s;
H = 1 / (s+3);

T = simplify((-G) / (1 + G*H))

[N,D] = numden(T); stab = roots(double(flip(coeffs(D))))