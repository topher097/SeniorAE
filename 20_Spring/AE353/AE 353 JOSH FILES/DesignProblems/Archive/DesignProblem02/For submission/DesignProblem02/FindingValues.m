clear all, clc
load('DesignProblem02_EOMs.mat')

%% Loading Values
M = symEOM.M;
C = symEOM.C;
N = symEOM.N;
tau = symEOM.tau;
D = zeros(length(C));

%% Linearization
syms tau1 q1 q2 v1 v2 real
q=[q1;q2;v1;v2];
qD=[v1;v2];
T=[tau1;0];
qDD=M\(-C*qD-N+T);
A=[0, 0, 1, 0; 0, 0, 0, 1;simplify(jacobian(qDD,q))];
B=[0;0;jacobian(qDD,tau1)];

A = subs(A, q1, 0); A = subs(A, q2, 0); A = subs(A, v1, 0); A = subs(A, v2, 0);
A = double(A)
B = subs(B, tau1, 0); B = subs(B, q2, 0);
B = double(B)

C = eye(4)
D = zeros(size(C))'

%% Stability
stableTest = vpa(eig(A), 5)
for i=1:length(stableTest)
    if stableTest(i) > 0
        display('System not Stable')
    else
        break
    end
end

%% Controllability
W = ctrb(A,B)
Q = 5*eye(size(A))
R = 0.75;
K = lqr(A,B,Q,R)
kRef  = 1/(-C*inv(A-B*K)*B)

%% State Space Model
spec = stepinfo(ss((A-B*K), (B*kRef), C,D));