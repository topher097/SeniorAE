clear, clc

syms pDD pD p f real
eqn = pDD + 7*pD + 3*p + 4*p^3 == f;

x = [p; pD];
xD = [pD; solve(eqn, pDD)];
u = [f];
y = [pD];

pE = 0;

A = subs(jacobian(xD, x),pE)
B = jacobian(xD, u)
C = jacobian(y, x)