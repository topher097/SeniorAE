clear, clc
%% Insert provided data:
A = [0.50 -0.40 0.40 -0.60; -0.10 0.40 -0.60 -1.00; 0.00 -1.00 -0.40 0.30; -0.10 0.10 -0.90 0.10];
B = [-0.90; -0.80; -0.30; -0.80];
C = [0.40 -0.20 -0.30 0.20];
Qo = [1.10];
Ro = [4.90 -0.45 -0.40 -0.70; -0.45 3.60 0.00 -0.10; -0.40 0.00 3.90 0.25; -0.70 -0.10 0.25 4.90];

%% Calculations:
L = mat2str(lqr(A', C', inv(Ro), inv(Qo))')