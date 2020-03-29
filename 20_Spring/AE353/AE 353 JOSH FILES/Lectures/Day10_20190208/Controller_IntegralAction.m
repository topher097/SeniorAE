function func = Controller_IntegralAction
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

% Load gains
load('gainmatrix.mat');
data.K = K;
data.kRef = kRef;
data.kInt = kInt;

% Initialize integrator
data.v = 0;

end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators, data] = runControlSystem(sensors, references, parameters, data)
ze = 0;
zdote = 0;
x = [sensors.z - ze; sensors.zdot - zdote];
y = [sensors.z - ze];
r = [references.z - ze];
u = - data.K * x + data.kRef * r - data.kInt * data.v;
data.v = data.v + parameters.tStep * (y - r);
actuators.thrust = parameters.m * parameters.g + u;
end
