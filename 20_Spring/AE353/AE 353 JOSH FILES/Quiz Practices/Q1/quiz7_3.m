A = [0.4 -0.7 0.2 0.9; 0.1 0.0 0.6 0.7; 0.9 -0.9 0.6 0.1; -0.9 0.0 -0.4 0.8];
B = [-0.7 0.8 0.1 -0.4; 0.7 -0.3 0.3 0.0; 0.6 -0.9 -0.5 -0.3; -0.9 0.5 -0.9 -0.2];
C = [-0.1 0.0 0.9 -0.1];
D = [0.0 0.0 0.0 0.0];
K = [-0.1 -0.4 0.5 0.4; -0.3 -0.1 0.2 -0.6; -0.1 -0.3 -0.7 -0.8; -0.8 0.3 0.5 0.4];
t0 = 0.1;
x0 = [-0.6; 0.3; 0.5; -0.4];
t1 = 0.4;

x = expm((A-B*K)*(t1-t0))*x0
y = C*x