function func = Controller_StateFeedback
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

load('gainmatrix.mat');
data.K = K;

end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators, data] = runControlSystem(sensors, references, parameters, data)
ze = 0;
zdote = 0;
x = [sensors.z - ze; sensors.zdot - zdote];
u = - data.K * x;
actuators.thrust = parameters.m * parameters.g + u;
end
