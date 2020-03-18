syms j1 j2 j3 w1 w2 w3 wd1 wd2 wd3 t1 t3
x = [w1; w2; w3];
u = [t1; t3];
y = x;
eqn1 = t1 == j1*wd1 - (j2 - j3)*w2*w3;
eqn2 = 0 == j2*wd2 - (j3 - j1)*w3*w1;
eqn3 = t3 == j3*wd3 - (j1 - j2)*w1*w2;
xd = [solve(eqn1, wd1); solve(eqn2, wd2); solve(eqn3, wd3)];
%Jacobian to find values for A, B, C, D
A = jacobian(xd, x)
B = jacobian(xd, u)
C = jacobian(y, x)
D = jacobian(y, u)


