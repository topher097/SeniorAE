clear, clc

A = [-2 -3; 4 -5];
B = [-1; 0];
C = [-3 4];
D = [0];
syms s
w = 9.2;

H = simplify(C*inv(s*eye(size(A)) - A)*B);
Hw = double(subs(H, s, j*w));
M = abs(Hw)
Thet = angle(Hw)