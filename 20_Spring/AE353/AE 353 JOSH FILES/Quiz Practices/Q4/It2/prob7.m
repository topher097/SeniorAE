clear, clc

syms s

F = 3;
G = 2 + 7/s;
H = 1 / (s-3);

T = simplify((-1) / (1 + G*H))