clear, clc

syms pDD pD p f real

eqn = 9*pDD + 4*pD + p + 5*p^3 == f;

x = [p; pD];
xD = [pD; solve(eqn, pDD)];
u = [f];
y = [pD];

pE = -2;

A = subs(jacobian(xD, x), pE)
B = jacobian(xD, u)
C = jacobian(y, x)