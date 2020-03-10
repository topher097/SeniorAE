clear, clc

syms pDD pD p f real
eqn = 16*pDD + 3*pD + 80*sin(p) == f;

pE = -0.4;

x = [p; pD];
xD = [pD; solve(eqn, pDD)];
u = [f];
y = [pD];

A = subs(jacobian(xD, x), pE)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)