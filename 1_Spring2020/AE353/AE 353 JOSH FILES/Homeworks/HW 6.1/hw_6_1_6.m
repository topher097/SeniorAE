clear, clc
%% Insert provided data:
A = [-0.80 0.90; 0.00 -0.50];
B = [-0.80; 0.80];
C = [-0.40 -0.10];
L = [-5.50; -7.00];
xhat0 = [-0.50; -0.70];
t0 = 0.30;
h = 0.04;
u0 = [-0.20];
y0 = [1.00];

%% Calculations:
xDhat = A*xhat0 + B*u0 - L*(C*xhat0 - y0);

xHaat = xhat0 + xDhat*h