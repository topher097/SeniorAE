syms P(t)
ode1 = diff(P) == P*B*inv(R)*transpose(B)*P-P*A - transpose(A)*P-Q; 
odes = [ode1]; 
cond1 = P(t1) == M;
conds = [cond1];
S = dsolve(odes,conds); 
t = t0; 
d = subs(S)
K = inv(R)*transpose(B)*d; 
u00 = double(-K*x0)