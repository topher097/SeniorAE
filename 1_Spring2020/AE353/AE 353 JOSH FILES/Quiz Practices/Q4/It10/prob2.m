clear, clc

A = [-5];
B = [-3];
C = [4];
D = [0];
syms s
w = 5.0;

H = simplify(C*inv(s*eye(size(A)) - A)*B);
Hw = double(subs(H, s, j*w));
M = abs(Hw)
theta = angle(Hw)