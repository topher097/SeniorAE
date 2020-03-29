clear, clc

A = [4 4 -1; 3 -3 1; 5 2 4];
B = [-1; -2; -1];
C = [-2 -2 1];
D = [0];
syms s

G = simplify(C*inv(s*eye(size(A)) - A)*B)