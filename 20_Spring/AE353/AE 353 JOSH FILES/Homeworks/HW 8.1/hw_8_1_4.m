clear, clc
%% Insert provided data here:
A = [-4 -1 3; -3 -2 -3; -3 -2 -5];
B = [4; 0; -2];
C = [1 -3 -4];
K = [4 0 0];
L = [1; -3; 0];

%% Calculations -- do not modify:
syms s
G = -K*inv(s*eye(size(A)) - (A - B*K - L*C))*L