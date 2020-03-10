function func = Controller
% INTERFACE
%
%   sensors
%       .t          (time)
%       .q1         (first joint angle)
%       .q2         (second joint angle, relative to the first)
%       .v1         (first joint velocity)
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

%
% Here is a good place to initialize things...
%
data.A = [0 0 1 0;0 0 0 1;5.54651306230982 -61.2335042079004 -1.57624934894049 -0.832670851722909;-1.90235313468023 -10.7824213931303 -0.277556950574303 -0.368954491874528];
data.B =[0;0;3.15249869788097;0.555113901148606];
data.C = [0 1 0 0];
data.tau_e = [0];
data.K = [27.2213 -39.2300 7.9300 -17.5105];
data.kref = 1/(-data.C*inv(data.A-data.B*data.K)*data.B);
data.v = 0;
data.kInt = 15;
data.x_e = [0;0;0;0];
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors, references, parameters, data)
x = [sensors.q1;sensors.q2;sensors.v1;sensors.v2]-data.x_e;
data.v = data.v+(sensors.q2-references.q2)*parameters.tStep
u = -data.K*x + data.kref*references.q2 + data.tau_e + data.kInt*data.v;
actuators.tau1 = u;
data.reference = references.q2;
error = references.q2-sensors.q2
function q2des = Test(t)
    if t < 15
        q2des = 0;
    else
        q2des = sin(t - 15);
    end
end

end
