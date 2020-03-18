function func = Controller
% INTERFACE
%
%   sensors
%       .t          (time)
%       .q2         (second joint angle, relative to the first)
%
%   references
%       .q2         (desired angle of second joint)
%
%   parameters
%       .tStep      (time step)
%       .tauMax     (maximum torque that can be applied)
%       .symEOM     (symbolic description of equations of motion)
%       .numEOM     (numerc description of equations of motion)
%
%   data
%       .whatever   (yours to define - put whatever you want into "data")
%
%   actuators
%       .tau1       (torque applied about first joint)

% Do not modify this function.
func.init = @initControlSystem;
func.run = @runControlSystem;

% If you want sensor data to be delayed, set func.iDelay to some
% non-negative integer (this is the number of time steps of delay).
func.iDelay = 0;
end

%
% STEP #1: Modify, but do NOT rename, this function. It is called once,
% before the simulation loop starts.
%

%
% STEP #1: Modify, but do NOT rename, this function. It is called once,
% before the simulation loop starts.
%

function [data] = initControlSystem(parameters,data)
%% Loading EOMs
%% Loading EOMs
load('DesignProblem02_EOMs.mat')
%% Inserting provided data
Qo = [0.60];
Ro = [4.00 0.10 0.10 -0.35; 0.10 3.60 0.65 -0.25; 0.10 0.65 4.90 0.60; -0.35 -0.25 0.60 3.40];
Qc = [3.50 0.45 -0.60 -0.20; 0.45 3.60 -0.30 0.35; -0.60 -0.30 4.20 -0.45; -0.20 0.35 -0.45 4.70];
Rc = [1.30];
x0 = [-0.12; 0.39; -0.40; 0.30];
t1 = 1.32;
t2 = 2.78;
d = -0.15;
syms s
%% Equilibrium Points
M = symEOM.M; C = symEOM.C; N = symEOM.N; tau = symEOM.tau;
syms q1 q2 v1 v2 tau1 real

q = [q1; q2];
qD = [v1; v2];

q1 = pi;
q2 = 0.34;
v1 = 0;
v2 = 0;

eqM = [pi; 0.34; 0; 0];
eqN = [-6.48];
u = [tau1];
y = [q2];

qDD = inv(M)*(tau-C*qD-N);
x = [q; qD];
xD = [qD; qDD];

A = jacobian(xD, x);
B = jacobian(xD, u);
C = jacobian(y, x);

A = double(subs(A, [x; u], [eqM; eqN]));
B = double(subs(B, [x;u], [eqM; eqN]));
C = [0 1 0 0];

L = lqr(A', C', inv(Ro), inv(Qo))';
K = lqr(A, B, Qc, Rc);
kRef = inv(-C*inv(A-B*K)*B);

data.A = A; data.B = B; data.C = C; data.L = L; data.K = K; data.kRef = kRef;
data.x0 = x0; data.t1 = t1; data.t2 = t2; data.d = d;

end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors, references, parameters, data)
data.r = 0.5*sensors.t;

if sensors.t == 0
    data.r = 0;
elseif sensors.t == d
    data.r = data.d;
end

actuators.tau1 = 0;
end
