clear, clc

syms pDD pD p b

pE = 0.3;

eqn = 3*pDD + 10*pD + 30*sin(p) == b;

xD = [solve(eqn, pDD), pD];
x = [pD; p];
u = [b];
y = [p];

A = vpa(subs(jacobian(xD, x), pE), 6)
B = vpa(subs(jacobian(xD, u), pE), 6)
C = jacobian(y, x)
D = jacobian(y, u)