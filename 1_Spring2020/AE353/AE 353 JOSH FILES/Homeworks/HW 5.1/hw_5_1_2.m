clear, clc
%% Insert provided data below:
A = [0.50000000 -0.80000000; 0.70000000 0.00000000];
B = [0.80000000; -0.20000000];
K = [5.77371429 2.79485714];
Q = [0.70000000 0.00000000; 0.00000000 0.01000000];
R = [0.23000000];
t0 = 0.40000000;
x0 = [0.33000000; 0.70000000];

%% Calculations -- do not modify
syms t real
x = expm((A-B*K)*(t-t0))*x0;
u = -K*x;

cost = int((x'*Q*x + u'*R*u), t, t0, Inf);

cost = vpa(cost,5)