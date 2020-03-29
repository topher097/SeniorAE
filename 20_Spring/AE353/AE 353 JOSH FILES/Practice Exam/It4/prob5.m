clear, clc
%% Insert equations
syms rD r p v pD r p

eqn1 = rD + 2*r - 2*p == 4*v;
eqn2 = pD - 5*r + 4*p == 0;

x = [r; p];
xD = [solve(eqn1, rD); solve(eqn2, pD)];
y = [p];
u = [v];

%% Linearizing
A = jacobian(xD, x)
B = jacobian(xD, u)
C = jacobian(y, x)
D = jacobian(y, u)