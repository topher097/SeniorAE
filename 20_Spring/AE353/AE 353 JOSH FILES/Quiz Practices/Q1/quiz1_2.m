clear, clc

syms eta etaD etaDD tau

nE = 0;

eqn = 5*etaDD + etaD + 9*eta + 2*eta^3 == tau;

xD = [etaD; solve(eqn, etaDD)];
x = [eta; etaD];
y = [eta];
u = [tau];

A = vpa(subs(jacobian(xD, x), nE), 3)
B = vpa(jacobian(xD, u), 3)
C = jacobian(y, x)
D = jacobian(y, u)