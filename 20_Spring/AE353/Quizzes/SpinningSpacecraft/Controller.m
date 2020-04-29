function func = Controller
% INTERFACE
%
%   sensors
%       .t          (time)
%       .w2         (angular velocity about body-fixed y axis)
%
%   references
%       .w1         (desired angular velocity about body-fixed x axis)
%
%   parameters
%       .tStep      (time step)
%       .tauMax     (maximum torque that can be applied by the actuator)
%
%   data
%       .whatever   (yours to define - put whatever you want into "data")
%
%   actuators
%       .tau        (torque applied about body-fixed z axis)

% Do not modify this function.
func.init = @initControlSystem;
func.run = @runControlSystem;
end

%
% STEP #1: Modify, but do NOT rename, this function. It is called once,
% before the simulation loop starts.
%

function [data] = initControlSystem(parameters,data)

%
% Here is a good place to initialize things...
%

data.A = [0 -1.9270277895448 0.121653207650093;-1.52309311827483 0 0;-0.164244449954975 0 0];
data.B = [0;0;0.4149377593361];
data.C = [0 1 0];
data.K = [151.868238495446 -171.267480678074 9.52331887552897];
data.L = [-3.99469271391717;3.54106350067691;-0.281962248264304];
data.xhat = [0; 0; 0];
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors, references, parameters, data)
y = [sensors.w2 - -0.189391925546168];
u = -data.K*data.xhat;
data.xhat = data.xhat + (data.A*data.xhat + data.B*u - data.L*(data.C*data.xhat - y))*parameters.tStep;
actuators.tau = u;
disp(y)
end
