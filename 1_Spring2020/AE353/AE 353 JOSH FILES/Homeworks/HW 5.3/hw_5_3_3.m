clear, clc
%% Insert Provided data:
A = -0.80;
B = 0.20;
Q = 0.10;
R = 2.90;
M = 0.60;
t0 = 0.00;
x0 = 0.48;

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