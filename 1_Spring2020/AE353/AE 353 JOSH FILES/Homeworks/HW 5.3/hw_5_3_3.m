clear, clc
%% Insert Provided data:
A = -0.70;
B = -0.90;
Q = 9.20;
R = 8.20;
M = 1.00;
t0 = 0.00;
x0 = 0.92;

%% Calculations -- do not modify:
t1 = t0 + input('Timestop: '); % Change the right value
syms P(t)
ode1 = diff(P) == P*B*inv(R)*transpose(B)*P-P*A - transpose(A)*P - Q;
odes = [ode1];
cond1 = P(t1)==M;
conds = [cond1];

S = dsolve(odes, conds);
t = t0;
d = subs(S);
k = double(inv(R)*transpose(B)*d) 