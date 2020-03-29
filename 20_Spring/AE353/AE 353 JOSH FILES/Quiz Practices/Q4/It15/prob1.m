clear, clc

syms s
A = [-4 -5; -2 -4];
B = [-1; -4];
C = [-3 4];
K = [2 -2];
L = [-4; 0];
kRef = inv(-C*inv(A-B*K)*B);
G = simplify(-K*inv(s*eye(size(A)) - (A-B*K-L*C))*L)