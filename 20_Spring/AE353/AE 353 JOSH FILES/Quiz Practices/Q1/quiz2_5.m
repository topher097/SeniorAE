clear, clc

A = [0.8 0.0 0.3; -0.5 0.4 0.6; -0.3 0.9 0.9];
B = [0.8 -0.1; 0.7 -0.7; 0.4 -0.3];
C = [-0.5 -0.2 -0.1];
D = [0.0 0.0];
K = [0.3 -0.9 0.7; 0.9 -0.5 -0.1];
t0 = 0.1;
x0 = [0.9; -0.2; 0.9];
t1 = 0.4;

x_ = expm((A-B*K)*(t1 - t0))*x0;
x = mat2str(expm((A-B*K)*(t1 - t0))*x0)
y = C*x_