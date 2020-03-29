clear, clc

syms s
A = [0 3; -4 -5];
B = [-5; 3];
C = [0 -1];
K = [-3 4];
L = [2; 3];

G = simplify(-K*inv(s*eye(size(A)) - (A-B*K-L*C))*L)