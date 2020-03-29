clear, clc
%% Insert provided data:
A = [-0.30 -0.90; -0.70 0.40];
B = [-0.90; -0.90];
C = [-0.10 -0.20];
L = [20.60; -30.80];
xhat0 = [-0.20; -0.30];
t0 = 0.60;
h = 0.10;
u0 = [0.90];
y0 = [0.30];
%% Calculations:
xDhat = A*xhat0 + B*u0 - L*(C*xhat0 - y0);

xHaat = xhat0 + xDhat*h;

disp(mat2str(xHaat));