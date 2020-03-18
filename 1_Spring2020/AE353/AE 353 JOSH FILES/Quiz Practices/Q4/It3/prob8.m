clear, clc

syms s
F = 4;
G = 5*s + 1 + 14/s;
H = 1 / (s + 6);

T = simplify((1) / (1 + H*G))

[N, D] = numden(T);
denom = double(flip(coeffs(D))); stab = vpa(roots(flip(denom)),2)