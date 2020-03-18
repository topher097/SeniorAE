clear, clc

syms s
F = 4;
G = 5*s + 2 + 3/s;
H = 1/s;

T = simplify((1) / (1 + H*G))

