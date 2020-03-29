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
data.t = [];
data.z = [];
data.zdot = [];
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators, data] = runControlSystem(sensors, references, parameters, data)
references.z = 0;

z_e = 0;
k = [0.6, 1];
x = [sensors.z - z_e; sensors.zdot];

actuators.thrust = parameters.m*parameters.g - k*x;
end

