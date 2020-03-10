clear, clc

syms s
F = 2;
G = 5*s + 3 + 12/s;
H = (3*s - 3) / (s^2 - 18);

T = simplify((-H) / (1 + G*H))

[N,D] = numden(T);
stability = roots(double(flip(coeffs(D))))
stability2 = roots(double(coeffs(D)))