clear, clc
%% Insert provided data here:
A = [-0.70 0.60 0.80; 0.20 -0.60 0.90; -0.30 -0.90 0.70];
B = [-0.60; 0.50; 0.30];
C = [-0.90 -0.50 -0.20];
L = [-11.80; 17.20; -35.90];
x0 = [0.10; -0.40; 0.60];
xhat0 = [-0.70; -0.30; 0.40];
t0 = 0.90;
t1 = 1.00;

%% Calculations: do not modify:
e = expm((A-L*C)*(t1 - t0))*(xhat0 - x0);

disp(mat2str(e));