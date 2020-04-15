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

data.A = [0 0 1 0;0 0 0 1;0 12.2587386997666 -0.256095881239535 -0.175384783925179;0 11.4596167485103 -0.131538587941162 -0.163951810706152];
data.B = [0;0;0.853652937465116;0.438461959803875];
data.C = [0.975897449330606 -1.9 0 0];
data.K = [-1.73205080756887 81.3065120475402 -5.0807703295951 28.1885430839567];
data.L = [-13.5741831806995;-11.2161791981673;-38.1070176313917;-36.2324763083857];
data.xhat = [0.95;1.7907963267949;0;0];
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors, references, parameters, data)
y = [sensors.p_hori - 0.487948731380586];
u = -data.K*data.xhat;
data.xhat = data.xhat + (data.A*data.xhat + data.B*u - data.L*(data.C*data.xhat - y))*parameters.tStep;
actuators.f1 = u;
end
