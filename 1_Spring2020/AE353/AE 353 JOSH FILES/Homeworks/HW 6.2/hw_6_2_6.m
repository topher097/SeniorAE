clear, clc
%% Insert provided data
A = [0.40 0.10 0.80; 0.30 0.20 -0.50; 0.00 0.40 -0.60];
B = [-0.10; -0.20; -0.90];
C = [-0.60 -0.50 -0.40];
K = [-6.90 -4.10 -1.90];
L = [-266.00; 256.20; 69.40];
t0 = 0.20;
h = 0.08;
xhat0 = [-0.40; -0.50; -0.20];
r0 = 0.80;
y0 = [-0.30];

%% Calculations -- do not modify
kref = kRef(A,B,C,K);

u0=-K*xhat0+kref*r0;

x_h=xhat0+(A*xhat0+B*u0-L*(C*xhat0-y0))*h;

u0 = mat2str(u0)
xh = mat2str(x_h)