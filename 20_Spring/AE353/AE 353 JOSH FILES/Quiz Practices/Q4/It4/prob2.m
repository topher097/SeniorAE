clear, clc

syms s
F = 2;
G = 2*s + 3 + 15/s;
H = 1 / (s - 6);

T = simplify((-H) / (1 + H*G))

[N,D] = numden(T); denom = vpa(roots(flip(double(flip(coeffs(D))))),2)