clear, clc

syms s

F = 4; G = 5; H = (3*s) / (s^2 + 8);

T = simplify((F*G*H) / (1 + G*H))

[N,D] = numden(T); stab = roots(double(flip(coeffs(D))))