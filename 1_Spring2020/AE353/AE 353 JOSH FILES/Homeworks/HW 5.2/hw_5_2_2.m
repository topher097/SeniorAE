clear, clc
%% Insert provided data here
A = [-0.10 -0.90; -0.60 -0.60];
B = [1.00; -1.00];
q = 2.40;
t0 = 0.50;
x0 = [0.43; -0.89];

%% Calculations -- do not modify
Q = mat2str(q.*eye(length(B)))
R = 1