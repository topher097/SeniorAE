clear, clc

syms pDD pD p f

eqn = 20*pDD + 2*pD + 100*cos(p) == f;

x = [p ; pD];
xD = [pD ; solve(eqn, pDD)];
u = [f];
y = [p];

pE = -1;

A = subs(jacobian(xD, x), pE)
B = subs(jacobian(xD, u), pE)
C = jacobian(y, x)
D = jacobian(y, u)