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

data.A = [0 1 0 0 0 0;
          0 0 0 1 0 0;
          0 0 0 0 0 1;
          0 0 0 0 -g 0;
          0 0 0 0 0 0;
          0 0 0 0 0 0];
data.B = [0 0;
          0 0;
          0 0;
          0 0;
          1/m 0;
          0 1/J];
end

function [actuators, data] = runControlSystem(sensors, references, parameters, data)
% Get parameters and stuff
mg = parameters.g*parameters.m;

% Define states
x = [sensors.q1;
     sensors.q2; 
     sensors.q3; 
     sensors.q1dot; 
     sensors.q2dot; 
     sensors.q3dot];

% Calculate force of rotors
fR = mg/2;
fL = mg/2;

% Set thrust of rotors
actuators.fR = fR;
actuators.fL = fL;
end







