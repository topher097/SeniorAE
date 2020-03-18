clear, clc

A = [-1 -3 -1; 0 -5 -4; 0 5 1];
B = [2; -4; 5];
C = [3 -3 0];
D = [0];
syms s

w = 9.2;

H = simplify(C*inv(s*eye(size(A)) - A) * B);  Hw = double(subs(H, s, j*w));

magnitude = abs(Hw)
w
theta = angle(Hw)