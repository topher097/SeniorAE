clear, clc

syms pDD pD p f real
pE = -1;

eqn = 7*pDD - 4*pD + 10*p - 2 == f;

x = [p; pD];
xD = [pD; solve(eqn, pDD)];
y = [pD];
u = [f];

A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)