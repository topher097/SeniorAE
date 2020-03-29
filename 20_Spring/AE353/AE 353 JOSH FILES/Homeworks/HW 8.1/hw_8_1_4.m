clear, clc
%% Insert provided data here:
A = [-2 5; 0 1];
B = [1; 5];
C = [5 -1];
K = [3 3];
L = [2; 5];

%% Calculations -- do not modify:
syms s
G = -K*inv(s*eye(size(A)) - (A - B*K - L*C))*L