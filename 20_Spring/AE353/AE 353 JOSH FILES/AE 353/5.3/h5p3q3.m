clear 
clc
A = -0.30;
B = 0.30;
Q = 5.50;
R = 9.80;
M = 1.00;
t0 = 0.00;
x0 = 0.57;

t1 = 100000000000000000000000000000000 +t0; 
syms P(t)
ode1 = diff(P) == P*B*inv(R)*transpose(B)*P-P*A-transpose(A)*P-Q; 
odes = [ode1]; 
cond1 = P(t1)==M; 
conds= [cond1]; 
S = dsolve(odes,conds); 
t = t0; 
d = subs(S); 
k = double(inv(R)*transpose(B)*d)