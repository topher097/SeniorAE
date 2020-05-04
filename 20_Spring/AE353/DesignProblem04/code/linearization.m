clc;
clear all;
load('DP04 eom.mat');
Q = symEOM.f;
bm = 0.4;        % meters
rm = 0.2;        % meters
roadwidth = 3;  % meters
v_road = 1.5;   % guess
r_road = inf;     % guess
w_road = v_road/r_road;

syms elateral eheading phi phidot v w tauR tauL
elateraldot = -v*sin(eheading);
eheadingdot = w-((v*cos(eheading))/(v_road+w_road*elateral))*w_road;
input = [tauR; tauL];
state = [elateral; eheading; phi; phidot; v; w];

gdot = [elateraldot; eheadingdot; phidot; Q];
g_numeric = matlabFunction(gdot,'vars',{[elateral; eheading; phi; phidot; v; w; tauR; tauL]});
% elat ehead phi phidot v w tauR tauL
equi = [0; 0; 0; 0; v_road; w_road; 0; 0]; 

opts = optimoptions(@fsolve,'Algorithm','levenberg-marquardt','display','off');
[g_sol, g_numeric_at_f_sol, exitflag] = fsolve(g_numeric,equi,opts);
equiPoints = g_sol;
xhat_guess = -equiPoints(1:end-2);
%xhat_guess = [0;0;0;0;0;0];

dL = (roadwidth*0.5 + elateral)/(cos(eheading)) - bm/2;
dR = (roadwidth*0.5 - elateral)/(cos(eheading)) - bm/2;
wR = v/rm + (bm*w)/(2*rm);
wL = v/rm - (bm*w)/(2*rm);

y = [dR; dL; wR; wL];
y_e = double(subs(y, [state; input], g_sol));

A = double(subs(jacobian(gdot, state), [elateral; eheading; phi; phidot; v; w; tauR; tauL], g_sol));
B = double(subs(jacobian(gdot, input), [elateral; eheading; phi; phidot; v; w; tauR; tauL], g_sol));
C = double(subs(jacobian(y, state),[elateral; eheading; phi; phidot; v; w; tauR; tauL], g_sol));

Qc = diag([5, 50, 1000, 10, .1, 100]);  % elat ehead phi phidot v w
Rc = diag([.1, .1]);              % tuaR tauL
Qo = diag([100, 100, .1, .1]);        % dR dL wR wL
Ro = diag([100, 500, 1, 1, .1, 10]);  % elat ehead phi phidot v w

K = lqr(A, B, Qc, Rc);
L = lqr(A', C', inv(Ro), inv(Qo))';

kRef = -1./(C*inv(A-B*K)*B);


% disp(sprintf('data.A = %s;', mat2str(A)));
% disp(sprintf('data.B = %s;', mat2str(B)));
% disp(sprintf('data.C = %s;', mat2str(C)));
% disp(sprintf('data.K = %s;', mat2str(K)));
% disp(sprintf('data.L = %s;', mat2str(L)));
% disp(sprintf('data.xhat = %s;', mat2str(xhat_guess)));
% disp(sprintf('data.x_e = %s;\n', mat2str(equiPoints)));
% 
% disp(sprintf('y = [sensors.dL - %s; sensors.dR - %s; sensors.wL - %s; sensors.wR - %s];', y_e(1), y_e(2), y_e(3), y_e(4)));
% 
% disp(sprintf('equilibrium: %s;\n\n', mat2str(round(equiPoints,5))));

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

save('control.mat', 'A', 'B', 'C', 'K', 'L', 'rm', 'bm', 'v_road', 'kRef', 'xhat_guess', 'equiPoints', 'y_e')
    

