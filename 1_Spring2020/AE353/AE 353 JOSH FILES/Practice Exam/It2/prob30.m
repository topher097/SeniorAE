clear, clc

A = [-1];
B = [-5];
C = [4];
D = [0];

w = 9.1;
syms s

H = simplify(C * inv(s* eye(size(A)) - A) * B);

Hw = double(subs(H, s, j*w));
M = abs(Hw)
theta = angle(Hw)