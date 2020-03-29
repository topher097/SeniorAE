clear, clc

A = [-1 4; -5 -2];
B = [-5; -3];
C = [-1 2];
D = [0];
syms s
w = 4.6;

H = simplify(C*inv(s*eye(size(A)) - A)*B);

Hw = double(subs(H, s, j*w));
m = abs(Hw)
theta = angle(Hw)