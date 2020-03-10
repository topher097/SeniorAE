function func = Controller
% INTERFACE
%
%   sensors
%       .t          (time)
%       .q1         (first joint angle)
%       .q2         (second joint angle, relative to the first)
%       .v1         (fir;st joint velocity)
%       .v2         (second joint velocity)
%
%   references
%       .q2         (desired angle of second joint)
%
%   parameters
%       .tStep      (time step)
%       .tauMax     (maximum torque that can be applied)
%       .symEOM     (symbolic description of equations of motion)
%       .numEOM     (numerc description of equations of motion)
%
%   data
%       .whatever   (yours to define - put whatever you want into "data")
%
%   actuators
%       .tau1       (torque applied about first joint)

% Do not modify this function.
func.init = @initControlSystem;
func.run = @runControlSystem;
end

%
% STEP #1: Modify, but do NOT rename, this function. It is called once,
% before the simulation loop starts.
%

%
% STEP #1: Modify, but do NOT rename, this function. It is called once,
% before the simulation loop starts.
%

function [data] = initControlSystem(parameters,data)

end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors, references, parameters, data)
x = [sensors.q1; sensors.q2; sensors.v1; sensors.v2];
K = [-61.5478836439645 3016.30166461283 -187.581170783617 1178.86471847935]; 
u = -K*x;
actuators.tau1 = u;
end 