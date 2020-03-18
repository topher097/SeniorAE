clear, clc

A = [-5 1 0; 4 -4 4; -5 0 -3];
B = [5; 0; 4];
C = [3 -5 1];
K = [5 -1 1];
L = [-1; -1; 1];

syms s

G = -K*inv(s*eye(size(A)) - (A-B*K-L*C))*L