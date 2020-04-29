syms w1 w2 w3 w1d w2d w3d T
J1 = 2.74;
J2 = 0.65;
J3 = 2.41;

eq1 = -1 == J1*w1d - (J2-J3)*w2*w3;
eq2 = 0 == J2*w2d - (J3-J1)*w1*w3;
eq3 = T == J3*w3d - (J1-J2)*w1*w2;

x = [w1; w2; w3];
xd = [w1d; w2d; w3d];

equi = [0; 0; 3; 0];

g = solve([eq1, eq2, eq3], xd)
g = [g.w1d; g.w2d; g.w3d]

g_numeric = matlabFunction(g,'vars',{[w1; w2; w3; T]});

opts = optimoptions(@fsolve,'Algorithm','levenberg-marquardt','display','off');
[g_sol, g_numeric_at_f_sol, exitflag] = fsolve(g_numeric,equi,opts);

state = [w1; w2; w3];
input = [T];

A = double(subs(jacobian(g, state), [w1; w2; w3; T], g_sol));
B = double(subs(jacobian(g, input), [w1; w2; w3; T], g_sol));
o = [w2];
C = double(subs(jacobian(o, state),[w1; w2; w3; T], g_sol));

disp(sprintf('data.A = %s;', mat2str(A)));
disp(sprintf('data.B = %s;', mat2str(B)));
disp(sprintf('data.C = %s;', mat2str(C)));

Qo = [1.00];
Ro = [3.60 0.85 0.05; 0.85 2.90 0.05; 0.05 0.05 2.30];
Qc = [2.80 -0.10 -0.25; -0.10 3.20 0.10; -0.25 0.10 2.30];
Rc = [1.40];

K = lqr(A, B, Qc, Rc);
L = lqr(A', C', inv(Ro), inv(Qo))';
y_e = [g_sol(2)];
xhat_guess = [0.08; 0.46; 0.33; 0];


disp(sprintf('data.K = %s;', mat2str(K)));
disp(sprintf('data.L = %s;', mat2str(L)));
disp(sprintf('data.xhat = %s;\n', mat2str(xhat_guess(1:1:3,:))));

disp(sprintf('y = [sensors.w2 - %0.15g];', y_e(1)));

disp(sprintf('equilibrium: %s;', mat2str(g_sol)));
x0 = [0.08; 0.46; 0.33];
t1 = 1.64;
t0 = 0;
D = [0];
xt = expm((A - B*K)*(t1-t0)) * x0
y = C*xt



