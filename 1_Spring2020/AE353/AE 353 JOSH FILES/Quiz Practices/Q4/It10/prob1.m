clear, clc

syms s
F = 5;
G = 2*s + 3 + 15/s;
H = 1/(s-10);

T = simplify(1 / (1 + H*G))