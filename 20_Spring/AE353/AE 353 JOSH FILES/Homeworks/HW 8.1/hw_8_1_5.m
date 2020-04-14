clear, clc
syms s
w = 55.6;
H = -8 / (s + 1);

Hw = double(subs(H, s, j*w))
M = abs(Hw)
theta = angle(Hw)