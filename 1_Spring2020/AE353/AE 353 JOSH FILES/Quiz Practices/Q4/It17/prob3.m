clear, clc

A = [-2 -2; 2 -3];
B = [5; 3];
C = [5 5];
K = [0 4];
L = [4; -2];
syms s

G = simplify(-K*inv(s*eye(size(A)) - (A-B*K-L*C))*L)