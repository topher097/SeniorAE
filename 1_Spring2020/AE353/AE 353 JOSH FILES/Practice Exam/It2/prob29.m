clear, clc

syms s

F = 2;
G = 3;
H = 1 / (s + 9);

T = simplify((H) / (1 + G*H))

[N,D] = numden(T); stable =  roots(double(flip(coeffs(D))))