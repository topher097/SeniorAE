clear, clc

A = [-3 -1 3; 5 -5 1; -4 -1 -3];
B = [0; -2; 2];
C = [-4 3 -2];
K = [3 -1 1];
L = [-4; 0; -4];

syms s
kRef = inv(-C*inv(A-B*K)*B);
G = -K*inv(s*eye(size(A)) - (A - B*K - L*C))*L