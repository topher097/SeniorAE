clear, clc

A = [-4 -2; -4 -3];
B = [1; -1];
C = [-1 3];
D = [0];

syms s
w = 8.4;

H = simplify(C*inv(s*eye(size(A)) - A)*B);
Hw = double(subs(H, s, j*w));
M = abs(Hw)
Theta = angle(Hw)