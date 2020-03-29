clear, clc
%% Insert provided data here
A = [-0.10 0.90 0.50 0.70; 0.20 -0.40 0.50 -0.30; 0.10 -0.70 0.10 0.20; 0.80 0.10 0.20 -0.70];
B = [0.90; -0.10; -0.10; 0.00];
q = 8.40;
t0 = 1.00;
x0 = [0.51; -0.63; -0.55; 0.71];

%% Calculations -- do not modify
Q = mat2str(q.*eye(length(B)))
R = 1