clear, clc
%% Insert provided data:
A = [-4];
B = [-4];
C = [2];
D = [0];

%% Calculations -- do not modify
syms s
H = simplify(C * inv(s * eye(size(A)) - A) * B)

w = 2.8;
Hw = double(subs(H, s, j*w))
M = abs(Hw)
theta = angle(Hw)
