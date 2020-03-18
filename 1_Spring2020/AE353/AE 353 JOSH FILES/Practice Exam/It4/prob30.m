clear, clc
%% Insert provided data:
A = [1 -3 -4; 2 -3 -1; 2 0 2];
B = [-4; 3; 0];
C = [1 5 0];
D = [0];

syms s
%% Calculations
G = simplify(C*inv(s*eye(size(A)) - A)*B)