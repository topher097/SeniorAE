clear, clc

A = [0 1; 2 1];
B = [3; -1];
C = [-4 -3];
D = [0];

syms s

G = simplify(C*inv(s*eye(size(A)) - A)*B)