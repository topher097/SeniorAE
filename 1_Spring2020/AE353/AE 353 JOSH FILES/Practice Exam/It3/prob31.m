clear, clc

A = [1 -1; 2 -4];
B = [-3; -3];
C = [-1 1];
K = [0 -4];
L = [-4; -3];
syms s

kRef = inv(-C*inv(A-B*K)*B);

G = simplify(-K*inv(s*eye(size(A)) - (A-B*K-L*C))*L)
