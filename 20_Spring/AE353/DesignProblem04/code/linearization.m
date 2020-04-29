clc;
clear all;

load('DP04 eom.mat');
f = symEOM.f;
b = 0.4;        % meters
r = 0.2;        % meters
roadwidth = 3;  % meters
v_road = .5;
w_road = .5;

syms elateral eheading phi phidot v w tauR tauL
input = [tauR; tauL];
elateraldot = -v*sin(eheading);
eheadingdot = w-((v*cos(eheading))/(v_road+w_road*elateral));
state = [elateral; eheading; phi; phidot; v; w];

g = [tauR; tauL; f];
g = [elateraldot; eheadingdot; phi; f];
g_numeric = matlabFunction(g,'vars',{[elateral; eheading; phi; phidot; v; w; tauR; tauL]});
xhat_guess = [0; 0; 0; 0; 0; 0];
equi = [0; 0; .1; 0; .5; 0; 0.1; 0.1]; 

opts = optimoptions(@fsolve,'Algorithm','levenberg-marquardt','display','off');
[g_sol, g_numeric_at_f_sol, exitflag] = fsolve(g_numeric,equi,opts);
equiPoints = g_sol;

r_road = v_road/w_road;
dL = (roadwidth*.5+elateral)/(cos(eheading)) - b/2;
dR = (roadwidth*.5-elateral)/(cos(eheading)) - b/2;
wR = v/w*r*cos(eheading);
wL = v/w*r*sin(eheading);

A = double(subs(jacobian(g, state), [elateral; eheading; phi; phidot; v; w; tauR; tauL], g_sol))
B = double(subs(jacobian(g, input), [elateral; eheading; phi; phidot; v; w; tauR; tauL], g_sol))
o = [dR, dL, wR, wL, r_road];
C = double(subs(jacobian(o, state),[elateral; eheading; phi; phidot; v; w; tauR; tauL], g_sol))

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
disp(sprintf('data.xhat = %s;', mat2str(xhat_guess(1:1:5,:))));
disp(sprintf('data.x_e = %s;\n', mat2str(equiPoints)));

disp(sprintf('y = [sensors.phi - %s; sensors.airspeed - %s];', y_e(1), y_e(2)));

disp(sprintf('equilibrium: %s;\n\n', mat2str(equiPoints)));

ControllabilityCondition = rank(ctrb(A,B));
ObservabilityCondition = rank(obsv(A,C));
if ControllabilityCondition == size(A,1)
    disp('System is controllable!')
end
if ObservabilityCondition == size(A,1)
    disp('System is obsevable!')
end
