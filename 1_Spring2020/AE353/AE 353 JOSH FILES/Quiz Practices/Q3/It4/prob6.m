clear, clc

syms zDD zD z v real

eqn = 2*zDD + 9*zD + 20*sin(z) == v;

x = [z; zD];
xD = [zD; solve(eqn, zDD)];
y = [zD];
u = [v]

A = subs(jacobian(xD, x), -0.3)
B = subs(jacobian(xD, u), -0.3)
C = jacobian(y, x)
D = jacobian(y, u)