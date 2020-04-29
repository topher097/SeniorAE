clc;
clear all;


syms psi psidot psiddot tau
eq = tau == 5*psiddot + 0.2*psidot - 10*cos(psi) + 5*sin(psi);
f = solve(eq, tau)
%f_sol = double(subs(f, [psi psidot psiddot], [0, 0, 0]))

% g = [tau];
% g_numeric = matlabFunction(g,'vars',{[psi; psidot; tau]});
% xhat_guess = [0; 0; 0];

equi = [-.1; subs(tau, [psi, psiddot], [-.1, 0.5]); 0.5];
oe = sqrt((1-cos(-.1))^2 + (2-sin(-.1))^2)
me = double(solve(subs(eq, [psi psiddot tau], [-.1 .05 0]), psidot))

%g_numeric = matlabFunction(g,'vars',{[psi; psidot; psiddot; tau]});

opts = optimoptions(@fsolve,'Algorithm','levenberg-marquardt','display','off');
[g_sol, g_numeric_at_f_sol, exitflag] = fsolve(g_numeric,equi,opts);

state = [psi; psidot];
input = [tau];
d = sqrt((1-cos(psi))^2 + (2-sin(psi))^2);

A = double(subs(jacobian(g, state), [psi; psidot; psiddot; tau], g_sol));
B = double(subs(jacobian(g, input), [psi; psidot; psiddot; tau], g_sol));
o = [d];
C = double(subs(jacobian(o, state), [psi; psidot; psiddot; tau], g_sol));

Qo = [0.70];
Ro = [2.90 0.30; 0.30 1.20];
Qc = [1.60 -0.10; -0.10 2.70];
Rc = [0.60];

K = lqr(A, B, Qc, Rc);
L = lqr(A', C', inv(Ro), inv(Qo))';
psiE = g_sol(1);
y_e = [sqrt((1-cos(psiE))^2 + (2-sin(psiE))^2)];

disp(sprintf('data.A = %s;', mat2str(A)));
disp(sprintf('data.B = %s;', mat2str(B)));
disp(sprintf('data.C = %s;', mat2str(C)));
disp(sprintf('data.K = %s;', mat2str(K)));
disp(sprintf('data.L = %s;', mat2str(L)));
disp(sprintf('data.xhat = %s;\n', mat2str(xhat_guess(1:1:4,:))));

disp(sprintf('y = [sensors.p_hori - %0.15g];', y_e(1)));

disp(sprintf('equilibrium: %s;', mat2str(g_sol)));
