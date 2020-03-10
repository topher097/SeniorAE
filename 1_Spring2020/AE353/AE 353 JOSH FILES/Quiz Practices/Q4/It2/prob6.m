clear, clc

syms s
A = [-4 0 5; -5 -4 1; -2 -4 -2];
B = [0; -1; 4];
C = [0 3 5];
D = [0];

G = simplify(C*inv(s*eye(size(A)) - A)*B)