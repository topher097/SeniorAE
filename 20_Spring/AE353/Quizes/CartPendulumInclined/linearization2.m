clc;
clear all;

load('eom.mat');


syms q1 q2 q1d q2d q1dd q2dd f1
g = [0; 0] == -inv(M)*C*[q1d; q2d] - inv(M)*N + [f1; 0]
f = solve(g(1), f1)
f_sol = double(subs(f, [q2, q1d, q2d], [0, 0, 0]))

equi = [0.5; 0; 0; 0; 0; 0];

g_numeric = matlabFunction(g,'vars',{[q1; q2; q1d; q2d; f1]});

opts = optimoptions(@fsolve,'Algorithm','levenberg-marquardt','display','off');
[g_sol, g_numeric_at_f_sol, exitflag] = fsolve(g_numeric,equi,opts)

A = double(subs(jacobian(g, state), [theta; phi; xdot; ydot; thetadot; phidot], g_sol));
B = double(subs(jacobian(g, input), [theta; phi; xdot; ydot; thetadot; phidot], g_sol));
o = [phi; xdot*cos(theta)+ydot*sin(theta)];
C = double(subs(jacobian(o, state),[theta; phi; xdot; ydot; thetadot; phidot], g_sol));

Qc = diag([200, 1, 1, 500, 1]);
Rc = diag([1]);
Qo = diag([5, 5]);
Ro = diag([200, 1, 1, 1000, 1]);

K = lqr(A, B, Qc, Rc);
L = lqr(A', C', inv(Ro), inv(Qo))';

y_e = [phiE; xdotE*cos(thetaE)+ydotE*sin(thetaE)];

disp(sprintf('data.A = %s;', mat2str(A)));
disp(sprintf('data.B = %s;', mat2str(B)));
disp(sprintf('data.C = %s;', mat2str(C)));
disp(sprintf('data.K = %s;', mat2str(K)));
disp(sprintf('data.L = %s;', mat2str(L)));
disp(sprintf('data.xhat = %s;\n', mat2str(xhat_guess(1:1:5,:))));

disp(sprintf('y = [sensors.phi - %s; sensors.airspeed - %s];', y_e(1), y_e(2)));

disp(sprintf('equilibrium: %s;', mat2str(equiPoints)));
