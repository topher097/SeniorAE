clear all;
close all;
clc;

%%
syms tau theta zeta thetadot zetadot real
load('eom.mat')
f = symEOM.f;

x = [zeta; zetadot; theta; thetadot];
xdot = [zetadot; f(1); thetadot; f(2)];
u = [tau];

theta_e = 0;
zeta_e = 0;
thetadot_e = 0;
zetadot_e = 0;
tau_e = 0;

% Double turns the symbolic expression into a floating point matrix
A = double(subs(jacobian(xdot, x), [zeta; theta; zetadot; thetadot; tau], [zeta_e; theta_e; zetadot_e; thetadot_e; tau_e]));
B = double(subs(jacobian(xdot, u), [zeta; theta; zetadot; thetadot; tau], [zeta_e; theta_e; zetadot_e; thetadot_e; tau_e]));
C = [1 0 0 0];
D = [0];
    
disp(A)
disp(B)
Q = diag([25, 20, 15, 5]);
R = diag([.1]);
[K, P] = lqr(A, B, Q, R);

kRef = -1/(C*inv(A - B * K)*B);
kInt = -5;
eig_c = eig(A-B*K)
eig_o = eig(A)

%%
% Determine the steady state error given step response (with and without
% disturbance)
G = [C, 0];
E = [A-B*K -B*kInt ; G];
F1 = [B*kRef ; -1];
F1a = [B*kRef+B ; -1];
F2 = [B ;0];
Am = E;
Bm = [F1 F2];
Bma = [F1a F2];
Cm = G;

% No disturbance
sys1 = ss(Am,Bm,Cm,D);
S1 = stepinfo(sys1, 'SettlingTimeThreshold', 0.05);
s1_risetime = S1.RiseTime;
s1_timetopeak = S1.PeakTime;
s1_overshoot = S1.Overshoot;
s1_settlingtime = S1.SettlingTime;
s1_error = 0;
disp(S1)

% Disturbance
sys2 = ss(Am,Bma,Cm,D);
step(sys2)
S2 = stepinfo(sys2, 'SettlingTimeThreshold', 0.05);
s2_risetime = S2.RiseTime;
s2_timetopeak = S2.PeakTime;
s2_overshoot = S2.Overshoot;
s2_settlingtime = S2.SettlingTime;
s2_error = 0;
disp(S2)
