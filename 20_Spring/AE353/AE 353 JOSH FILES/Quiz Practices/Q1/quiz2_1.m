clear,clc

nE = 0;

syms eta etaD etaDD nu

eqn = 36*etaDD + 5*etaD + 120*sin(eta) == nu;

xD = [solve(eqn, etaDD), etaD];
x = [etaD, eta];
y = [etaD];
u = [nu];

A = vpa(subs(jacobian(xD, x), nE),3)
B = vpa(jacobian(xD, u),3)
C = jacobian(y, x)
D = jacobian(y, u)