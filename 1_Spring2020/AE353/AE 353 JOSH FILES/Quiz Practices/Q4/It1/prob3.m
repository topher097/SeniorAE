clear, clc
%% Provided data
A = [-4];
B = [1];
C = [-3];
D = [0];
syms s
w = 6.2;
%% Calculations
H = simplify(C*inv(s*eye(size(A)) - A)*B);

Hw = double(subs(H, s, j*w));
M = abs(Hw)
theta = angle(Hw)