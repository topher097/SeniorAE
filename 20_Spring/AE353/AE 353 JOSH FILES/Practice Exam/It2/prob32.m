clear, clc

A = [-3 3; 1 -4];
B = [-5; 3];
C = [1 -1];
D = [0];
syms s

H = simplify(C*inv(s*eye(length(A)) - A) * B)