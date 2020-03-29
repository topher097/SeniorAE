clear, clc

syms mDD mD m f real

eqn = mDD - 3*mD - 7*m == 3*f;

x = [m; mD]; xD = [mD; solve(eqn, mDD)];
u = [f]; y = [m];

A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)