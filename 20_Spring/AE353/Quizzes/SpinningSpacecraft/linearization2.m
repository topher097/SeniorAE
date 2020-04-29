clc;
clear all;

load('eom.mat');


syms q1 q2 q1d q2d q1dd q2dd f1
g = [q1d; q2d; -inv(M)*C*[q1d; q2d] - inv(M)*N + inv(M)*[f1; 0]];
%f = solve(g(1), f1)
%f_sol = double(subs(g, [q2, q1d, q2d], [0, 0, 0]))


equi = [0.5; -11/50; 0; 0; 0; 0; 5.5662];

g_numeric = matlabFunction(g,'vars',{[q1; q2; q1d; q2d; q1dd; q2dd; f1]});

opts = optimoptions(@fsolve,'Algorithm','levenberg-marquardt','display','off');
[g_sol, g_numeric_at_f_sol, exitflag] = fsolve(g_numeric,equi,opts);

state = [q1; q2; q1d; q2d];
input = [f1];
phi = 0.22;
l = 1.90;


A = double(subs(jacobian(g, state), [q1; q2; q1d; q2d; q1dd; q2dd; f1], g_sol));
B = double(subs(jacobian(g, input), [q1; q2; q1d; q2d; q1dd; q2dd; f1], g_sol));
o = [q1*cos(phi)+l*cos(phi+(pi/2)+q2)];
C = double(subs(jacobian(o, state),[q1; q2; q1d; q2d; q1dd; q2dd; f1], g_sol));

%Qc = diag([10, 100000, .01, .01]);
%Rc = diag([.001]);
Qc = [3.90 0.40 0.15 -0.25; 0.40 3.80 0.15 0.00; 0.15 0.15 4.80 0.25; -0.25 0.00 0.25 3.80];
Rc = [1.30];
%Qo = diag([1]);
%Ro = diag([10, 10000, .1, .1]);
Qo = [1.60];
Ro = [4.60 -0.10 0.40 0.15; -0.10 4.10 0.40 -0.15; 0.40 0.40 4.20 0.00; 0.15 -0.15 0.00 4.10];

K = lqr(A, B, Qc, Rc);
L = lqr(A', C', inv(Ro), inv(Qo))';
q1E = g_sol(1);
q2E = g_sol(2);
y_e = [q1E*cos(phi)+l*cos(phi+(pi/2)+q2E)];
xhat_guess = [l/2; pi/2+phi; 0; 0; 0; 0];

disp(sprintf('data.A = %s;', mat2str(A)));
disp(sprintf('data.B = %s;', mat2str(B)));
disp(sprintf('data.C = %s;', mat2str(C)));
disp(sprintf('data.K = %s;', mat2str(K)));
disp(sprintf('data.L = %s;', mat2str(L)));
disp(sprintf('data.xhat = %s;\n', mat2str(xhat_guess(1:1:4,:))));

disp(sprintf('y = [sensors.p_hori - %0.15g];', y_e(1)));

disp(sprintf('equilibrium: %s;', mat2str(g_sol)));
