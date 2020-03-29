clear, clc

mE = 0.6;

syms mDD mD m b

eqn = 3*mDD + 5*mD + 30*sin(m) == b;

xD = [mD; solve(eqn, mDD)];

x = [m; mD];
y = [mD];
u = [b];

A = vpa(subs(jacobian(xD, x), mE), 6)
B = vpa(subs(jacobian(xD, u), mE), 6)
C = jacobian(y, x)
D = jacobian(y, u)