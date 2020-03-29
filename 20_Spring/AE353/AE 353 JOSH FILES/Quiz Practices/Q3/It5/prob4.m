clear, clc
syms pDD pD p f real
pE = 4;

eqn = 8*pDD + 7*pD + 7*p + 2*p^3 == f;

x = [p; pD];
xD = [pD; solve(eqn, pDD)];
y = [pD];
u = [f];

A = subs(jacobian(xD, x), pE)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)