function func = Controller
% INTERFACE
%
%   sensors
%       .t              (time)
%       .p_hori         (horizontal position of mass on end of pendulum)
%
%   references
%       .q1             (desired position of cart along rod)
%
%   parameters
%       .tStep          (time step)
%       .fMax           (maximum force that can be applied)
%
%   data
%       .whatever       (yours to define - put whatever you want in here)
%
%   actuators
%       .f1             (force applied to cart)

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

function [actuators,data] = runControlSystem(sensors, references, parameters, data)
actuators.f1 = 0;
end
