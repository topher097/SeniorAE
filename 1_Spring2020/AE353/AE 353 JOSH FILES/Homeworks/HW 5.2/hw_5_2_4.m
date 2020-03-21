clear, clc
%% Insert provided data here
A = [1.00 -0.40; 0.60 0.00];
B = [0.30; -0.30];
t0 = 0.10;
x0 = [0.41; -0.83];

%% Calculations -- do not modify
r = 3; % Need to figure out how to calc r
Q = eye(length(B))+1/r;
Q = mat2str(Q,4)
R = [1]