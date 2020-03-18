clear, clc
%% Insert provided data:
A = [-3 0; -2 -1];
B = [-1; -5];
C = [-3 -3];
D = [0];
%% Calculations -- do not modify
syms s
G = simplify(C*inv(s*eye(size(A)) - A) * B)