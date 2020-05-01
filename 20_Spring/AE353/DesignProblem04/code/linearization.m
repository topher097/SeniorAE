clc;
clear all;

load('DP04 eom.mat');
f = symEOM.f;
b = 0.4;        % meters
r = 0.2;        % meters
roadwidth = 3;  % meters
v_road = .25;   % guess
r_road = 0;     % guess
w_road = 0;   

syms elateral eheading phi phidot v w tauR tauL
input = [tauR; tauL];
elateraldot = -v*sin(eheading);
eheadingdot = w-((v*cos(eheading))/(v_road+w_road*elateral));
state = [elateral; eheading; phi; phidot; v; w];

g = [elateraldot; eheadingdot; phidot; f];
g_numeric = matlabFunction(g,'vars',{[elateral; eheading; phi; phidot; v; w; tauR; tauL]});
xhat_guess = [0; 0; 0; 0; 0; 0];
% elat ehead phi phidot v w tauR tauL
equi = [0; 0; 0; 0; -v_road; 0; 0; 0]; 

opts = optimoptions(@fsolve,'Algorithm','levenberg-marquardt','display','off');
[g_sol, g_numeric_at_f_sol, exitflag] = fsolve(g_numeric,equi,opts);
equiPoints = g_sol;

r_road = v_road/w_road;
dL = (roadwidth*.5+elateral)/(cos(eheading)) - b/2;
dR = (roadwidth*.5-elateral)/(cos(eheading)) - b/2;
wR = v/r + (b*w)/(2*r);
wL = v/r - (b*w)/(2*r);

A = double(subs(jacobian(g, state), [elateral; eheading; phi; phidot; v; w; tauR; tauL], g_sol))
B = double(subs(jacobian(g, input), [elateral; eheading; phi; phidot; v; w; tauR; tauL], g_sol))
o = [dR, dL, wR, wL];
C = double(subs(jacobian(o, state),[elateral; eheading; phi; phidot; v; w; tauR; tauL], g_sol))

Qc = diag([1, 100, 100, 10, 50, 1]);  % elat ehead phi phidot v w
Rc = diag([1, 1]);              % tuaR tauL
Qo = diag([200, 200, 1, 1]);        % dR dL wR wL
Ro = diag([1, 10, 1, 1, 1, 1]);  % elat ehead phi phidot v w

K = lqr(A, B, Qc, Rc)
L = lqr(A', C', inv(Ro), inv(Qo))'

dL_E = (roadwidth*.5+g_sol(1))/(cos(g_sol(2))) - b/2;
dR_E = (roadwidth*.5-g_sol(1))/(cos(g_sol(2))) - b/2;
wL_E = g_sol(5)/r - (b*g_sol(6))/(2*r);
wR_E = g_sol(5)/r + (b*g_sol(6))/(2*r);
r_road_E = 0;
y_e = [dR_E; dL_E; wR_E; wL_E];

disp(sprintf('data.A = %s;', mat2str(A)));
disp(sprintf('data.B = %s;', mat2str(B)));
disp(sprintf('data.C = %s;', mat2str(C)));
disp(sprintf('data.K = %s;', mat2str(K)));
disp(sprintf('data.L = %s;', mat2str(L)));
disp(sprintf('data.xhat = %s;', mat2str(xhat_guess)));
disp(sprintf('data.x_e = %s;\n', mat2str(equiPoints)));

disp(sprintf('y = [sensors.dL - %s; sensors.dR - %s; sensors.wL - %s; sensors.wR - %s];', y_e(1), y_e(2), y_e(3), y_e(4)));

disp(sprintf('equilibrium: %s;\n\n', mat2str(round(equiPoints,5))));

ControllabilityCondition = rank(ctrb(A,B));
ObservabilityCondition = rank(obsv(A,C));
if ControllabilityCondition == size(A,1)
    disp('System is controllable!')
else
    disp('System is NOT controllable!')
end
if ObservabilityCondition == size(A,1)
    disp('System is obsevable!')
else
    disp('System is NOT obsevable!')
end
if(all(eig(A-B*K) < 0))
    disp('System is stable!') 
else 
    disp('System is NOT stable!')
end

save('control.mat', 'A', 'B', 'C', 'K', 'L', 'xhat_guess', 'equiPoints', 'y_e')


