clear, clc
syms s
A = [-1 1; -4 -4];
B = [2; -1];
C = [-1 0];
K = [4 -5];
L = [0; 4];

G = -K*inv(s*eye(size(A)) - (A - B*K - L*C))*L
