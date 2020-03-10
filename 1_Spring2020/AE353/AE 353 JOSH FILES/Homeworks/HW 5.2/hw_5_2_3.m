clear, clc
%% Insert provided data here
A = [0.60 0.00 -1.00; 0.40 -0.50 0.80; 0.40 0.50 0.50];
B = [0.50; -0.60; -0.30];
r = 5.40;
t0 = 0.90;
x0 = [0.10; 0.08; 0.83];

%% Calculations -- do not modify
Q = 1/r*eye(length(B));
Q = mat2str(Q,4)
R = [1]