%Initializing all variables 
DesignProblem02('Controller', 'display', false)

load('DesignProblem02_EOMs.mat');

M = symEOM.M;
C = symEOM.C;
N = symEOM.N;
tau = symEOM.tau; 

% symbolic variables
syms q1 q2 v1 v2 tau1 real
q = [q1; q2];
qd = [v1; v2];
qdd = inv(M)*tau - inv(M)*N - inv(M)*C*qd;

%define state, and input
x = [q; qd];
xdot = [qd; qdd];
u = [tau1];

% equilibrium points - eq_p = [q1_e; q2_e; v1_e; v2_e]
q1_e = pi;
eq_p = [pi; 0; 0; 0];  
tau1_e = 0;

% state space model (where x = m - m_e, u = n - n_e)

% - take partial derivatives
A = jacobian(xdot, x);
B = jacobian(xdot, u);

%- plug in equilibrium values and convert from symbolic to numeric
A = double(subs(A, [x;u], [eq_p; tau1_e]));
B = double(subs(B, [x;u], [eq_p; tau1_e]));

% Check if the open loop system is stable
s_openloop = eig(A);

%%Creating a K with a chosen p matrix
p = [-10; -34; -16; -5]; 
Q = eye(4);
R = [1];
k = acker(A,B,p);
data.K = acker(A,B,p);
A_m = A - B * k;
s_c = eig(A_m);

C = [1 0 0 0];
kRef = 1/(-C*inv(A-B*k)*B);

%check if the model is controllable 
W = ctrb(A, B);
W = det(W);
r1 = rank(W);

W2 = ctrb(A_m, B);
r2 = rank(W2);


%Running the State FeedBack simulation

DesignProblem02('Controller','display', false, 'datafile','dataOpen.mat')

%Plotting closed loop system
load('dataOpen.mat')
t = processdata.t;
q1 = processdata.q1;
q2 = processdata.q2;
v1 = processdata.v1;
v2 = processdata.v2;


figure(1)
clf;

plot(t, q1, 'm-', 'linewidth', .15);
hold on;
plot(t, q2, 'g-', 'linewidth', .15);


set(gca, 'fontsize', 18);
set(gca, 'fontsize', 12);
xlabel('t');
ylabel('q(t)');
legend({'q_1 (simulation)', 'q_2 (simulation)'});
title('State Feedback Results - Joint Angles');
xlim([0 30])
ylim([-4.5 4.5])

figure(2)
clf;

plot(t, v1, 'k-', 'linewidth', .15);
hold on;
plot(t, v2, 'b-', 'linewidth', .15);

set(gca, 'fontsize', 18);
set(gca, 'fontsize', 12);
xlabel('t');
ylabel('v(t)');
legend({'v_1 (simulation)', 'v_2 (simulation)'});
xlim([0 30])
ylim([-4.5 4.5])

%%Plotting State FeedBack Error
figure(3)
clf;
q1_e = pi;
plot(t, q1-q1_e, 'm-', 'linewidth', .15);
hold on;

set(gca, 'fontsize', 18);
set(gca, 'fontsize', 12);
xlabel('t');
ylabel('Error');
legend({'q_1 Error'});
title('Verification of State Feedback');
xlim([0 30])
ylim([-5 5])

%Refererence Tracking without disturbance
DesignProblem02('Controller', 'display', false, 'disturbance', false, 'reference', @(t) (pi)*heaviside(t-1), 'datafile', 'data.mat')
load('data.mat');


figure(4)
q2Max = max(processdata.q2);
t1 = processdata.t;
plot(t1,processdata.q2-pi);
xlabel('t');
ylabel('Error');
legend('Error');
title('Reference Tracking Steady State Error');
xlim([0 30])
ylim([-5 5])

%Refererence Tracking with disturbance
DesignProblem02('Controller', 'display', false, 'disturbance', true, 'reference', @(t) (pi)*heaviside(t-1), 'datafile', 'data1.mat')
load('data1.mat');


figure(5)
q2_1 = max(processdata.q2);
t1 = processdata.t;
plot(t1,q2_1-pi);
xlabel('t');
ylabel('Error');
legend('Error');
title('Reference Tracking Steady State Error with Disturbance');
xlim([0 30])
ylim([-10 10])