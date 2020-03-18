clear,clc

A = [0.0 -0.1; 0.6 0.0];
B = [0.8; 0.7];
C = [-0.2 0.4];
D = [0.0];
K = [0.5 -0.8];
t0 = 0.2;
x0 = [0.4; -0.2];
t1 = 0.5;

kRef = inv(-C*inv(A - B*K)*B);

Am = A-B*K;

x = expm(Am*(t1-t0))*x0

y = C*x