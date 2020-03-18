clear, clc

syms zDD zD z v real

eqn = 45*zDD + zD + 150*cos(z) == v;

x = [z; zD];
xD = [zD; solve(eqn, zDD)];
u = [v];
y = [zD];

zE = -0.9;

A = subs(jacobian(xD, x), zE)
B = jacobian(xD, u)
C = jacobian(y, x)