clear, clc
%% Insert provided data
A = [-2 -2 4; 0 1 -2; -2 4 -5];
B = [3; -5; -3];
C = [-4 -2 5];
D = [0];
w = 1.9;
syms s
%% Calculations
H = simplify(C*inv(s*eye(size(A)) - A)*B); Hw = double(subs(H, s, j*w));

Magnitude = abs(Hw)
Angle = angle(Hw)