clear, clc

syms mD m q qD q v real

eqn1 = mD + 3*m + 3*q == 0;
eqn2 = qD + q == 4*v;

x = [m; q]; xD = [solve(eqn1, mD); solve(eqn2, qD)];
u = [v]; y = [m];

A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)