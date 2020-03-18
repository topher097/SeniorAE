function Day22_20190315_fsolve
clc

% % Using fsolve to find the zeros of a simple function
% 
% syms z real
% f = z^2 - 1
% 
% z_guess = 0;
% f_at_z_guess = subs(f, [z], [z_guess]);
% 
% f_numeric = matlabFunction(f, 'vars', {[z]})
% f_numeric_at_z_guess = f_numeric(z_guess)
% 
% [z_sol, f_numeric_at_z_sol, exitflag] = fsolve(f_numeric, z_guess)
% 
% clear z
% z = linspace(-3, 3, 100);
% clf;
% plot(z, f_numeric(z), 'k', 'linewidth', 2);
% hold on;
% axis([-3 3 -3 5]);
% grid on;
% plot(z_sol, f_numeric(z_sol), 'r.', 'markersize', 36);

% Using fsolve to find the zeros of a not-so-simple function

load('DesignProblem03_EOMs.mat');
f = symEOM.f;
syms theta phi xdot ydot thetadot phidot real

v = [theta; phi; xdot; ydot; thetadot; phidot];
f_numeric = matlabFunction(f, 'vars', {v})

v_guess = [1; 2; 3; 4; 5; 6];
f_numeric_at_v_guess = f_numeric(v_guess)

% With default options
[v_sol, f_numeric_at_v_sol, exitflag] = fsolve(f_numeric, v_guess)

% With non-default options (specify algorithm to avoid MATLAB warning,
% specify very small tolerances to get better accuracy)
options = optimoptions(...
    'fsolve', ...                           % name of solver
    'algorithm', 'levenberg-marquardt', ... % algorithm to use
    'functiontolerance', 1e-12, ...         % smaller means higher accuracy
    'steptolerance', 1e-12);                % smaller means higher accuracy
[v_sol, f_numeric_at_v_sol, exitflag] = fsolve(f_numeric, v_guess, options)

end
