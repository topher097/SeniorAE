clear, clc

syms zDD zD z v real

eqn = 8*zDD + zD + 3*z + z^3 == v;

x = [z; zD];
xD = [zD; solve(eqn, zDD)];
u = [v];
y = [zD];

zE = 1;

A = subs(jacobian(xD, x), zE)
B = jacobian(xD, u)
C = jacobian(y, x)