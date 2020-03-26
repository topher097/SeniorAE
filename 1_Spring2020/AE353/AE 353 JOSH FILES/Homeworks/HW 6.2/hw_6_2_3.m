clear, clc
%% Insert provided data
A = [-0.20 0.80 0.10 0.60; -0.80 0.30 -0.80 0.10; 0.40 0.80 -0.90 -0.70; 0.40 0.00 0.30 0.30];
B = [-0.30; -0.70; 0.80; 0.80];
C = [-0.70 -0.40 0.30 0.80];
K = [-4.10 4.80 -3.00 12.30];
L = [75.30; 4.50; -47.30; 93.80];
x0 = [0.90; 0.20; -0.90; 0.60];
xhat0 = [1.90; 0.60; -1.10; 0.20];
t0 = 0.70;
t1 = 1.20;

%% Calculations -- do not modify
[m, n] = size(A);
F = [A-B*K -B*K; zeros(size(A)) A-L*C];
sol = expm(F*(t1-t0))*[x0;xhat0-x0];
xt1 = sol(1:n);
xhat1 = sol(n+1:2*n) + xt1;

xt1 = mat2str(xt1)
xhat1 = mat2str(xhat1)