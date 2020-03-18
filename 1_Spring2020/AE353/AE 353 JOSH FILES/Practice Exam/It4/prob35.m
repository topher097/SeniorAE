clear, clc
%% Insert relations
syms s
F = 3;
G = 5;
H = 1 / (s - 8);

%% Finding T
T = simplify((-H) / (1 + G*H))