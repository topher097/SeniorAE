clear, clc
%% Insert provided data here:
A = -0.20;
B = -0.80;
Q = 9.20;
R = 6.00;
M = 1.00;
t0 = 1.00;
x0 = 0.46;
t1 = 1.80;

%% Calculations -- do not modify:
syms P(t)
ode1 = diff(P) == P*B*inv(R)*transpose(B)*P-P*A - transpose(A)*P-Q;
odes = [ode1];

cond1 = P(t1) == M;
conds = [cond1];

S = dsolve(odes, conds);
t = t0;
d = subs(S);
K = inv(R)*transpose(B)*d;
u00 = double(-K*x0)