clear, clc

A = [-5];
B = [-2];
C = [-3];
D = [0];

syms s

w = 6.5;

H = simplify(C * inv(s * eye(size(A)) - A) * B);

Hw = double(subs(H, s, j*w))
M = abs(Hw)
theta = angle(Hw)