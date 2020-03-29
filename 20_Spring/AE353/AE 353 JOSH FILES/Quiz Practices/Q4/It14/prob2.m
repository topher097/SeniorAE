clear, clc

syms s
A = [1 3 -4; -4 2 1; -3 1 -2];
B = [3; -5; -4];
C = [3 4 3];
D = [0];

G = simplify(C*inv(s*eye(size(A))-A)*B)