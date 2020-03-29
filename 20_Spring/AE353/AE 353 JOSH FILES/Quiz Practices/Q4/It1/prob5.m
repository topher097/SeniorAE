clear, clc
%% Provided data
A = [5 1 0; -2 -5 3; 0 1 0];
B = [-4; 5; 1];
C = [-1 1 -2];
D = [0];
syms s

%% Calculations

G = simplify(C*inv(s*eye(size(A)) - A) * B)