clear, clc
%% Insert provided data:
A = [-3 0; -4 3];
B = [1; 3];
C = [0 4];
D = [0];
%% Calculations -- do not modify
syms s
G = simplify(C*inv(s*eye(size(A)) - A) * B)