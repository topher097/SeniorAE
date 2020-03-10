clear, clc

syms pDD pD p f real
eqn = 3*pDD + 10*pD + 8*p - 7 == f;
pE = -2;

x = [p; pD];
xD = [pD; solve(eqn, pDD)];
y = [pD];
u = [f];

A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)