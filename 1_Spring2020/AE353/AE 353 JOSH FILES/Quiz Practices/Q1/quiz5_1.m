clear,clc

syms mDD mD m b

eqn = mDD - 10*mD + 2*m == -5*b;

xD = [mD; solve(eqn, mDD)];
x = [m;mD];
u = [b];
y = [mD];

A = vpa(jacobian(xD, x), 6)
B = vpa(jacobian(xD, u), 6)
C = jacobian(y, x)
D = jacobian(y, u)