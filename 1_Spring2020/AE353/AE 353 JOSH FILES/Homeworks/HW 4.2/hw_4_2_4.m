clear, clc
%% Insert Provided Data Here:
A = [0.3 -0.8; -0.4 -0.1];
B = [0.2; 0.8];
F = [-0.5 1.6; 0.0 0.7];
G = [1.4; 0.6];

%% Calculations: Do not edit!
W = ctrb(A, B);
Wccf = ctrb(F, G);

Vi = Wccf*inv(W);
V = mat2str(inv(Vi))