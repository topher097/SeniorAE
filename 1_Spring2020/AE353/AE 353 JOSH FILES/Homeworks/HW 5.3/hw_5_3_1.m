clear, clc
%% Insert provided data here:
A = 0.30;
B = 0.20;
Q = 2.40;
R = 6.20;
M = 0.40;
t0 = 0.30;
x0 = -0.77;
t1 = 0.80;

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