clear, clc

syms s

A = [-3 3 -1; 1 -2 -3; -5 -2 1];
B = [2; 1; 2];
C = [3 -4 -3];
D = [0];

G = simplify(C*inv(s*eye(size(A))- A)*B)