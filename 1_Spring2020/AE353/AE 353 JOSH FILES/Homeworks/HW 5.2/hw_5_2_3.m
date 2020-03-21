clear, clc
%% Insert provided data here
A = [-0.60 0.70; 0.80 -0.60];
B = [1.00; -0.40];
r = 7.60;
t0 = 1.00;
x0 = [0.17; 0.15];

%% Calculations -- do not modify
Q = 1/r*eye(length(B));
Q = mat2str(Q,4)
R = [1]