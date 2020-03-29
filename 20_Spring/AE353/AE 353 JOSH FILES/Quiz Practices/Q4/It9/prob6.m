clear, clc

syms s
F = 2;
G = 5*s + 1 + 9/s;
H = 3 / (s^2 + 18);

T = simplify((F*G*H) / (1 + G*H))
