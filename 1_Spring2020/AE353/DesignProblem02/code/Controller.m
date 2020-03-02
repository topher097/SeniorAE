function func = Controller
% INTERFACE
%
%   sensors
%       .t          (time)
%       .zeta       (horizontal position of wheel center)
%       .theta      (angle of body with respect to vertical)
%       .zetadot    (horizontal linear velocity of wheel)
%       .thetadot   (angular velocity of body)
%
%   references
%       .zeta       (desired horizontal position of wheel center)
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
%       .tau        (torque applied by wheel to body)

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

function [actuators, data] = runControlSystem(sensors, references, parameters, data)
actuators.tau = 0;
end







