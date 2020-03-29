clear, clc

syms s
A = [-3];
B = [-4];
C = [4];
D = [0];

w = 0.6;
H = simplify(C*inv(s*eye(size(A)) - A)*B);

Hw = double(subs(H, s, j*w));
M = abs(Hw)
Theta = angle(Hw)