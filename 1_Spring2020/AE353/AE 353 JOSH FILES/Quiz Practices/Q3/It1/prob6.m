clear, clc
syms zDD zD z v real
eqn = 5*zDD + 2*zD + 8*z + z^3 == v;

zE = -2
vE = 8*zE + zE^3

xD = [zD; solve(eqn, zDD)];
x = [z; zD];
u = [v];
y = [zD];

A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)