function func = Controller
% INTERFACE
%
%   sensors
%       .t          (time)
%       .z          (position)
%       .zdot       (velocity)
%
%   references
%       .z          (desired position)
%
%   parameters
%       .tStep      (time step)
%       .g          (acceleration of gravity)
%       .m          (mass)
%       .maxthrust  (maximum allowable net thrust; the minimum is always 0)
%
%   data
%       .whatever   (yours to define - put whatever you want into "data")
%
%   actuators
%       .thrust     (net thrust)

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

end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators, data] = runControlSystem(sensors, references, parameters, data)
% 1.1.1
% sensors.z
% sensors.zdot
% parameters.m
% parameters.g
%  actuators.thrust = parameters.m * parameters.g - (0)*sensors.z - (0.1)*sensors.zdot;

% 1.2.1
% z_e = 1.3;
% x = [sensors.z - z_e; sensors.zdot];
% u = -[0.5, 0.2]*x;
% actuators.thrust = parameters.m * parameters.g - u;
% actuators.thrust = parameters.m * parameters.g - [1.0 0.2]*[sensors.z + 1.6; sensors.zdot];
end
