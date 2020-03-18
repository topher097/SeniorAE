clear, clc

syms pDD pD p f

eqn = 18*pDD + 5*pD + 60*sin(p) == f;

xD = [solve(eqn, pDD); pD];
pE = 0.2;

x = [pD; p];
u = [f];
y = [p];

A = vpa(subs(jacobian(xD, x), pE), 3)
B = vpa(subs(jacobian(xD, u), pE), 3)
C = jacobian(y, x)
D = jacobian(y, u)