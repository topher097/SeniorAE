%% State Space Model -- Linearization:
load('DesignProblem04_EOMs.mat');
% Parse the equations of motion.
f = symEOM.f;
% Define symbolic variables that appear in the equations of motion.
syms phi phidot v w tauR tauL elateral eheading rroad vroad vR wL real
f = [f; phidot; -v*sin(eheading); w-((v*cos(eheading))/(vRoad+wRoad*elateral))*wRoad];
p = [phi; phidot; v; w; elateral; eheading; tauR; tauL; rroad; vroad];
f_numeric = matlabFunction(f, 'vars', {p})
wR = (v + 

p_guess = [1; 2; 1; 1; 0; 0; 3; 3; 0; 0];
f_numeric_at_v_guess = f_numeric(p_guess)

% With default options
[p_sol, f_numeric_at_v_sol, exitflag] = fsolve(f_numeric, p_guess)

%Choose State
vRoad = 10;
wRoad = 0;
fsym=[f; phidot; -v*sin(eheading); w-((v*cos(eheading))/(vRoad+wRoad*elateral))*wRoad];

%Equilibrium Points
xhat = [0; 0; 0; 0; 0; 0];
eqState = [p_sol(1); p_sol(2); p_sol(3); p_sol(4); p_sol(5); p_sol(6)];
eqInput = [p_sol(7); p_sol(8)];
state = [phi; phidot; v; w; elateral; eheading];
input = [tauR; tauL];
output = [elateral; eheading; wR; wL];

%Linearization
A = double(vpa(subs(jacobian(fsym,state),[state; input],[eqState; eqInput])))
B = double(vpa(subs(jacobian(fsym,input),[state; input],[eqState; eqInput])))
C = double(vpa(jacobian(output, state))); C = [zeros(3,6); C]

controllability = cond(ctrb(A,B))
observability = cond(obsv(A,C))