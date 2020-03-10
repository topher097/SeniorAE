clear, clc
%% Input equation data
syms qDD qD q b real

qE = 2;

eqn = 7*qDD + qD + 3*q + 3*q^3 == b;

x = [qD; q]; xD = [solve(eqn, qDD); qD]; u = [b]; y = [q];

%% Linearizing
A = mat2str(double(subs(jacobian(xD, x), qE)))
B = mat2str(double(subs(jacobian(xD, u), qE)))
C = jacobian(y, x)
D = jacobian(y, u)