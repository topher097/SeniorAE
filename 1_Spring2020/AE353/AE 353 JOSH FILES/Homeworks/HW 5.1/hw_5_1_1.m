clear, clc
%% Insert provided data below
A = [0.10000000 0.10000000; -0.10000000 -0.10000000];
B = [-0.30000000; -0.30000000];
K = [-56.39000000 39.19000000];
Q = [0.83000000 0.00000000; 0.00000000 0.15000000];
R = [0.79000000];
M = [0.17000000 0.00000000; 0.00000000 0.88000000];
t0 = 0.60000000;
x0 = [-0.35000000; 0.23000000];
t1 = 1.70000000;

%% Calculations -- Do not modify

syms t real
x = expm((A-B*K)*(t-t0))*x0;
u = -K*x;

x1 = subs(x, t, t1);
firstCost = x1'*M*x1;
secondCost = int((x'*Q*x + u'*R*u), t, t0, t1);

cost = vpa(firstCost + secondCost, 5)