clear, clc

A = [-2];
B = [-4];
C = [2];
D = [0];
syms s
w = 7.4;

H = simplify(C*inv(s*eye(size(A)) - A)*B); Hw = double(subs(H, s, j*w));
m = abs(Hw)
w = w
theta = angle(Hw)