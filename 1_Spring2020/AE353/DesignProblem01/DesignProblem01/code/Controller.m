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

%
% Here is a good place to initialize things...
%
data.K = [.1, .1, .1, .1, .1, .1];
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators, data] = runControlSystem(sensors, references, parameters, data)
% Get paramters and stuff
references.q2 = 0;
mg = parameters.g*parameters.m;
J = parameters.J;
fMax = parameters.fmax;
K = data.K;

% Define states
x = [sensors.q1;
    sensors.q2; 
    sensors.q3; 
    sensors.q1dot; 
    sensors.q2dot; 
    sensors.q3dot];

% Calculate force of rotors
fR = mg - 0;
fL = 0;

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







