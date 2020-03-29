function func = Controller
% INTERFACE
%
%   sensors
%       .t          (time)
%       .w1         (angular velocity about body-fixed x axis)
%       .w2         (angular velocity about body-fixed y axis)
%       .w3         (angular velocity about body-fixed z axis)
%
%   references
%       .w1         (desired angular velocity about body-fixed x axis)
%
%   parameters
%       .tStep      (time step)
%       .J1         (moment of inertia about body-fixed x axis)
%       .J2         (moment of inertia about body-fixed y axis)
%       .J3         (moment of inertia about body-fixed z axis)
%       .tauMax     (maximum torque that can be applied by each actuator)
%
%   data
%       .whatever   (yours to define - put whatever you want into "data")
%
%   actuators
%       .tau1       (torque applied about body-fixed x axis)
%       .tau3       (torque applied about body-fixed z axis)

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

end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%


%%
function [actuators,data] = runControlSystem(sensors, references, parameters, data)
    %%
    w_e = [3 ; 0 ; 0];
    momInertia1=(parameters.J2-parameters.J3)/parameters.J1;
    momInertia2=(parameters.J1-parameters.J3)/parameters.J2;
    momInertia3=(parameters.J1-parameters.J2)/parameters.J3;
    %% Simplification values
    K = [2, 1, 1; 1, 1, 1];
    aMatrix=[0 momInertia1*w_e(3) momInertia1*w_e(2);-momInertia2*w_e(3) 0 momInertia2*w_e(1); momInertia3*w_e(2) momInertia3*w_e(1) 0];

    %% Eigenvalue Test
    B=[1/parameters.J1 0; 0 0; 0 1/parameters.J3]; 
    F = eig(aMatrix-B*K);
    
    %% Implementation of Controller
    actuators.tau1 = -K(1,1)*(sensors.w1 - w_e(1)) - K(1,2)*(sensors.w2 - w_e(2)) - K(1,3)*(sensors.w3 - w_e(3));
    actuators.tau3 = -K(2,1)*(sensors.w1 - w_e(1)) - K(2,2)*(sensors.w2 - w_e(2)) - K(2,3)*(sensors.w3 - w_e(3));
end
