clear, clc

syms pDD pD p f real
eqn = 5*pDD + 8*pD + 6*p + 6*p^3 == f;

x = [p; pD];
xD = [pD; solve(eqn, pDD)];
u = [f];
y = [p];

pE = 4;

A = subs(jacobian(xD, x), pE)
B = jacobian(xD, u)
C = jacobian(y, x)