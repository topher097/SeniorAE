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


function [data] = initControlSystem(sensors,parameters,data)
data.K = [22.8829284789174 -39.0184593006023 6.43740916248679 -15.7546540642683];
data.kRef = -19.5947;
data.r = 0;
data.kInt = 5;
data.v = 0;%int((sensors.q2 - data.r), sensors.t, 0, sensors.t);

end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors, references, parameters, data)
data.r = 0.5*sensors.t;
    if sensors.t <= 5
        data.r = 0.0872665; %5 degrees
    elseif sensors.t <= 10
        data.r = 0.174533;  %10 degrees 
    elseif sensors.t <= 15
        data.r = 0.261799;  %15 degrees
    else
        data.r = 0;
    end

data.x = [sensors.q1; sensors.q2; sensors.v1; sensors.v2];

actuators.tau1 = -data.K*data.x + data.kRef*data.r - data.kInt*data.v;
    end
