clear; clc;
%load OEMs
load('DesignProblem04_EOMs.mat')
F = symEOM.f

%define variables
syms phi phidot v w tauR tauL e_lat e_head v_road w_road real

%use Jacobian and given equations to calculate equilibrium points
vr=4;
phir = 0;
phidotr = 0;
data.w = 0;
eld = -v*sin(e_head);
ehd = w - ((v*cos(e_head))/(vr+data.w*e_lat))*data.w;
F=[phidot; F; eld; ehd];
x=[phi phidot v w e_lat e_head]';
u=[tauR tauL]';
vars=[phi phidot v w tauR tauL e_lat e_head]';
f_numeric = matlabFunction(F, 'vars', {vars});
vars_guess = [phir;phidotr;vr;0;0;0;0;0];
[v_sol, f_numeric_at_v_sol, exitflag] = fsolve(f_numeric, vars_guess, optimoptions(@fsolve, 'algorithm', 'levenberg-marquardt', 'display', 'off')); 
x_e = [v_sol(1) v_sol(2) v_sol(3) v_sol(4) v_sol(7) v_sol(8)]'
u_e = [v_sol(5) v_sol(6)]';

% Calculate A from equilibrium points
A = jacobian(F,x);
A = subs(A, [x',u'], [x_e', u_e']);
A = double(vpa(A,6))

% Calculate B from equilibrium points
B = jacobian(F,u);
B = subs(B, [x',u'], [x_e', u_e']);
B = double(vpa(B,6))

% Create C,K,L and adjust tuning variables for controller
C = [0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1]
Q = 50*diag([1000/100 10 2 690 1000 1000]);
R = 100*eye(2); 
K = lqr(A, B, Q, R)
Ro = 1*eye(size(A));
Qo = 800*eye(4);
L = lqr(A', C', inv(Ro), inv(Qo))'



save('Matrices','A','B','C','K','L','v_sol')

%% Analysis section
CMatrix = ctrb(A,B)
CMatrixRank = rank(CMatrix)
eigC = vpa(eig(A-B*K),3)

OMatrix = obsv(A,C)
OMatrixRank = rank(OMatrix)
eigO = vpa(eig(A-L*C),3)