clear, clc

syms nD n m b mD m

eqn1 = nD + 2*n - 2*m == -2*b;
eqn2 = mD - 4*m == 2*b;

xD = [solve(eqn1, nD), solve(eqn2, mD)];

x = [n; m];
u = [b];
y = [n];

A = vpa(jacobian(xD, x))
B = vpa(jacobian(xD, u))
C = vpa(jacobian(y, x))
D = vpa(jacobian(y, u))