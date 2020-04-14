clear, clc
%% Insert provided data
A = [-0.20 -0.60 -0.10 -0.10; -0.90 -0.30 -0.30 -0.10; -0.80 0.60 -0.50 -0.40; -0.80 0.90 -0.30 -0.90];
B = [0.50; 0.50; -0.70; 0.10];
C = [0.40 -0.20 0.80 -0.80];
K = [-743.50 572.50 -123.30 50.90];
L = [167.50; -94.70; -255.50; -158.40];
t0 = 0.80;
h = 0.04;
xhat0 = [0.80; 1.00; -0.90; 0.30];
r0 = -0.10;
y0 = [-0.40];

%% Calculations -- do not modify
kref = -1/(C*inv(A-B*K)*B);

u0=-K*xhat0+kref*r0;

x_h=xhat0+(A*xhat0+B*u0-L*(C*xhat0-y0))*h;

u0 = mat2str(u0)
xh = mat2str(x_h)