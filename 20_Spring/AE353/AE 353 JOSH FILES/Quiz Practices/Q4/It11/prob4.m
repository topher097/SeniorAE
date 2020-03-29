clear, clc

A = [-5];
B = [2];
C = [-3];
D = [0];
syms s
w = 3.0;

H = simplify(C*inv(s*eye(size(A)) - A)*B);
Hw = double(subs(H, s, j*w));

m = abs(Hw)
theta = angle(Hw)