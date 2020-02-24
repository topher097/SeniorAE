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


function [data] = initControlSystem(parameters, data)
data.q3e = 0;
g = parameters.g;
m = parameters.m;
J = parameters.J;
% Define the A matrix
data.A = [0 1 0 0 0 0;
          0 0 0 1 0 0;
          0 0 0 0 0 1;
          0 0 0 0 -g 0;
          0 0 0 0 0 0;
          0 0 0 0 0 0];
% Define the B matrix
data.B = [0 0;
          0 0;
          0 0;
          0 0;
          1/m 0;
          0 1/J];
% Define the K gain matrix
data.K = [0 6 0 0 5 0;
         -2.3 0 18 -3.25 0 7];
%disp('K = ');
%disp(data.K);
disp(eig(data.A-data.B*data.K));
end

function [actuators, data] = runControlSystem(sensors, references, parameters, data)
% Get parameters
mg = parameters.g*parameters.m;
fMax = parameters.fmax;
K = data.K;
r = parameters.r;   % Length of spar (distance from COM and applicatioon of force from rotor

% Define states and inputs
x = [sensors.q1; sensors.q2; sensors.q3; sensors.q1dot; sensors.q2dot; sensors.q3dot];
u = -K * x;

% Calculate force of rotors
thrust = u(1,1);
torque = u(2,1);
fR = (thrust - .5 * (thrust - torque/r)) + mg/2;
fL = (thrust - .5 * (thrust + torque/r)) + mg/2;

% Limit the force of rotors
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

% Set thrust of rotors
actuators.fR = fR;
actuators.fL = fL;
end







