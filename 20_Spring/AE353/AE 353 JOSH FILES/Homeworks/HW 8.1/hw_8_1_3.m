clear, clc
%% Insert provided data:
A = [4 -1 2; -2 -1 4; 4 -1 3];
B = [-4; -1; -4];
C = [-2 -5 -2];
D = [0];
%% Calculations -- do not modify
syms s
G = simplify(C*inv(s*eye(size(A)) - A) * B)