function func = Controller
% INTERFACE
%
%   sensors
%       .t          (time)
%       .q1         (horizontal position)
%       .q2         (vertical position)
%       .q3         (angle)
%       .q1dot      (horizontal velocity)
%       .q2dot      (vertical velocity)
%       .q3dot      (angular velocity)
%
%   references
%       .q2         (desired vertical position)
%
%   parameters
%       .tStep      (time step)
%       .g          (acceleration of gravity)
%       .m          (mass)
%       .J          (moment of inertia)
%       .r          (spar length)
%       .fmax       (maximum allowable thrust of either rotor; the minimum is always 0)
%
%   data
%       .whatever   (yours to define - put whatever you want into "data")
%
%   actuators
%       .fR         (thrust of right-hand rotor)
%       .fL         (thrust of left-hand rotor)

% Do not modify this function.
func.init = @initControlSystem;
func.run = @runControlSystem;
end

%
% STEP #1: Modify, but do NOT rename, this function. It is called once,
% before the simulation loop starts.
%

function [data] = initControlSystem(parameters, data)

% Define equilibrium point
data.me = [0;0;0;0;0;0];
data.ne = [7.3575;7.3575];

% Define state-space model
A = [0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1;0 0 -9.81 0 0 0;0 0 0 0 0 0;0 0 0 0 0 0];
B = [0 0;0 0;0 0;0 0;0.66666667 0.66666667;3 -3];

% Design controller (REPLACE)
Q = diag([5, 100, 1, 2, 2, .2]);
R = 10*diag([1, 1]);
[K, P] = lqr(A, B, Q, R);
data.K = K;

end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators, data] = runControlSystem(sensors, references, parameters, data)
fMax = 10;
% Parse sensor data to compute nonlinear state
m = [sensors.q1; sensors.q2; sensors.q3; sensors.q1dot; sensors.q2dot; sensors.q3dot];

% Compute state
x = m - data.me;

% Compute input
u = -data.K * x;

% Compute nonlinear input
n = u + data.ne;

% Parse nonlinear input to compute actuator values
fR = n(1);
fL = n(2);

if fR > fMax
    fR = fMax;
end
if fR < 0
    fR = 0;
end
if fL > fMax
    fL = fMax;
end
if fL < 0
    fL = 0;
end

actuators.fL = fL;
actuators.fR = fR;
end







