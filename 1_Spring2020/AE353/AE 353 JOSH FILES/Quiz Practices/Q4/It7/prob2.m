clear, clc
syms s
A = [0 0 0; 1 5 -2; -2 -1 -5];
B = [-5; 4; 2];
C = [-1 2 -2];
D = [0];

G = simplify(C*inv(s*eye(size(A)) - A) *B)