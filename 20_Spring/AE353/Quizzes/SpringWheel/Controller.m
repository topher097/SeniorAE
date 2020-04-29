function func = Controller
% INTERFACE
%
%   sensors
%       .t              (time)
%       .d              (distance between points p and q)
%
%   references
%       .d              (desired distance between points p and q)
%
%   parameters
%       .tStep          (time step)
%       .tauMax         (maximum torque that can be applied)
%
%   data
%       .whatever       (yours to define - put whatever you want in here)
%
%   actuators
%       .tau            (torque applied to flywheel)

% Do not modify this function.
func.init = @initControlSystem;
func.run = @runControlSystem;
end

%
% STEP #1: Modify, but do NOT rename, this function. It is called once,
% before the simulation loop starts.
%

function [data] = initControlSystem(parameters, data)



end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors, references, parameters, data)
y = [sensors.d - 0];
u = -data.K*data.xhat;
data.xhat = data.xhat + (data.A*data.xhat + data.B*u - data.L*(data.C*data.xhat - y))*parameters.tStep;
actuators.tau = u;
disp(y)
end
