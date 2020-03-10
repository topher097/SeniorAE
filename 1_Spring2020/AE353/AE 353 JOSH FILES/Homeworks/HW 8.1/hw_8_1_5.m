clear, clc
syms s
w = 89.2;
H = 3 / (s + 3);

Hw = double(subs(H, s, j*w))
M = abs(Hw)
theta = angle(Hw)