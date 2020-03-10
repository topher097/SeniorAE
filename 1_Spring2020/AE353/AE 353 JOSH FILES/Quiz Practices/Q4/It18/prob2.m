clear, clc

syms s
A = [-4 -5 4; 3 1 -2; -3 -2 -5];
B = [1; -1; 5];
C = [1 -1 -3];
K = [1 -2 1];
L = [3; -4; -3];

G = simplify(-K*inv(s*eye(size(A)) - (A-B*K-L*C))*L)