clear, clc

A = [-4 1; -1 -2];
B = [1; -5];
C = [4 -1];
D = [0];
syms s

G = simplify(C*inv(s*eye(size(A)) - A)*B)