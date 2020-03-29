clear; clc;
load('DesignProblem03_EOMs.mat');
f = symEOM.f;
syms theta phi xdot zdot thetadot phidot
f = [thetadot;phidot;symEOM.f]
v = [theta;phi;xdot;zdot;thetadot;phidot];
fnumeric = matlabFunction(f,'vars',{v});
%vguess = [0;0.0174533;7;-.5;0;0];
vguess = [0.0174533;0.10472;7;0;0;0];
[vsol,fnumericguess,exitflag] = fsolve(fnumeric,vguess)
x_e = vsol(1:5,:)
u_e = vsol(6)
x = v(1:5,:)
u = v(6)
ja = jacobian(f,x);
ja = subs(ja,[x;u],[x_e;u_e])
A = double([ja])
jb = jacobian(f,u);
jb = subs(jb,[x;u],[x_e;u_e]);
B = double([jb])
C = [1 0 0 0 0; 0 1 0 0 0];
Astr = mat2str(A)
Bstr = mat2str(B)

disp(Astr)
disp(Bstr)