clc;
clear all;

load('DesignProblem03_EOMs.mat');
f = symEOM.f;

syms x y xdot ydot phi phidot theta thetadot
input = [phidot];
state = [theta; phi; xdot; ydot; thetadot];

launch = 15; %degrees
g = [thetadot; phidot; f];
g_numeric = matlabFunction(g,'vars',{[theta; phi; xdot; ydot; thetadot; phidot]});
xhat_guess = [deg2rad(launch); 0; cos(deg2rad(launch)); sin(deg2rad(launch)); 0; 0];
equi = [0.05; 0.05; 5.95; -.05; 0; 0]; 
opts = optimoptions(@fsolve,'Algorithm','levenberg-marquardt','display','off');
[g_sol, g_numeric_at_f_sol, exitflag] = fsolve(g_numeric,equi,opts);
thetaE = g_sol(1); phiE = g_sol(2); xdotE = g_sol(3); ydotE = g_sol(4); thetadotE = g_sol(5); phidotE = g_sol(6);
equiPoints = [thetaE; phiE; xdotE; ydotE; 0; 0];

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
