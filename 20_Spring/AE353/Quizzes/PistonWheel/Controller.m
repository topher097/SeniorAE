function func = Controller
% INTERFACE
%
%   sensors
%       .t              (time)
%       .d              (distance between center of flywheel and point q)
%
%   references
%       .d              (desired distance between center of flywheel and point q)
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

%
% Here is a good place to initialize things...
%
data.A = [0 1;0 -0.0514387642842092];
data.B = [0;0.128596910710523];
data.C = [-0.773061224685229 0];
data.K = [1.67332005306815 4.94642545853847];
data.L = [-1.81559650961481;-0.75522254674216];
data.xhat = [0;0];
data.x_e = [0.7;0;0;0];
data.kRef = -2.1645;
data.t= 0;
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors, references, parameters, data)
y = [sensors.d - 0.9178];
u = -data.K*data.xhat + data.kRef*0.02*data.t;
data.xhat = data.xhat + (data.A*data.xhat + data.B*u - data.L*(data.C*data.xhat - y))*parameters.tStep;
data.t = data.t + parameters.tStep;
actuators.tau = u;
disp(y)
end
