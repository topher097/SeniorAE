clear, clc
syms s
A = [2 -5 -5; 5 4 1; 0 1 0];
B = [-4; 3; 5];
C = [-3 2 -5];
D = [0];

G = simplify(C*inv(s*eye(size(A)) - A)*B)