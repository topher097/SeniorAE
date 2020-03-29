clear, clc

A = [0 -4; 4 5];
B = [-4; 4];
C = [0 -4];
D = [0];
syms s

G = simplify(C*inv(s*eye(size(A)) - A)*B)