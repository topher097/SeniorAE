clear, clc
%% Insert provided data:
A = [-4];
B = [-2];
C = [-1];
D = [0];

%% Calculations -- do not modify
syms s
H = simplify(C * inv(s * eye(size(A)) - A) * B)

w = 8.5;
Hw = double(subs(H, s, j*w))
M = abs(Hw)
w = w
theta = angle(Hw)