clear, clc

A = [1 3; -4 4];
B = [-1; -2];
C = [-4 -1];
D = [0];

syms s
G = simplify(C*inv(s*eye(size(A)) - A)*B)