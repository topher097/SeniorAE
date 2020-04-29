clear, clc
%% Insert provided data:
A = [-1];
B = [-1];
C = [5];
D = [0];

%% Calculations -- do not modify
syms s
H = simplify(C * inv(s * eye(size(A)) - A) * B)

w = 7.1;
Hw = double(subs(H, s, j*w))
M = abs(Hw)
w = w
theta = angle(Hw)