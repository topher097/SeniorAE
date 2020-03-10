clear, clc
%% Insert provided data
A = [0.70 0.80 0.60; -0.80 0.30 -0.30; 0.80 0.00 0.00];
B = [-0.70; -0.60; 0.30];
C = [-0.50 0.90 -0.30];
K = [-6.20 0.40 -5.00];
L = [-10.50; -0.10; -7.30];
x0 = [-0.30; 0.70; 0.40];
xhat0 = [0.50; 0.30; 1.40];
t0 = 0.10;
t1 = 0.30;

%% Calculations -- do not modify
[m, n] = size(A);
F = [A-B*K -B*K; zeros(size(A)) A-L*C];
sol = expm(F*(t1-t0))*[x0;xhat0-x0];
xt1 = sol(1:n);
xhat1 = sol(n+1:2*n) + xt1;

xt1 = mat2str(xt1)
xhat1 = mat2str(xhat1)