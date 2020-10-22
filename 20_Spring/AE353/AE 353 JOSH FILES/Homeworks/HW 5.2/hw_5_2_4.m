clear, clc
%% Insert provided data here
A = [0.20 -0.60; 0.30 -0.60];
B = [-0.10; 0.30];
t0 = 0.60;
x0 = [-0.80; 0.93];

%% Calculations -- do not modify
r = 3; % Need to figure out how to calc r
Q = eye(length(B))+1/r;
Q = mat2str(Q,4)
R = [1]