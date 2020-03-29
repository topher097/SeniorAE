function func = Controller
% INTERFACE
%
%   sensors
%       .t          (time)
%       .q2         (second joint angle, relative to the first)
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

% If you want sensor data to be delayed, set func.iDelay to some
% non-negative integer (this is the number of time steps of delay).
func.iDelay = 0;
end

%
% STEP #1: Modify, but do NOT rename, this function. It is called once,
% before the simulation loop starts.
%

function [data] = initControlSystem(parameters,data)
    data.A = [0 0 1 0;0 0 0 1;-5.54651306230982 61.2335042079004 -1.57624934894049 -0.832670851722909;1.90235313468023 10.7824213931303 -0.277556950574303 -0.368954491874528];
    data.B = [0;0;3.15249869788097;0.555113901148606];
    data.C = [0 1 0 0];
    data.L = [17.5721371216029;6.91802556286302;60.6306315864427;23.8714543321831];
    data.K = [11.2096920091321 38.9971834523656 1.15720194495996 13.3146048861141];
    data.kRef = 19.5733834523656;
    data.equiState = [pi; 0; 0; 0];
    data.equiInput = [0];
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors, references, parameters, data)
    A = data.A; B = data.B; C = data.C; K = data.K; L = data.L; kRef = data.kRef;
    h = parameters.tStep;
    eqState = data.equiState; eqInput = data.equiInput;
    data.xhat = [0; 0; 0; 0];
    y = [sensors.q2]
    u = -K*data.xhat;
    
    d = -0.34; t1 = 0.58; t2 = 1.76;
    
    xhatdot = A*data.xhat + B*u - L*(C*data.xhat - y);
    data.xhat = data.xhat + h*xhatdot;
    
    if sensors.t < t1
        r = 0;
    else
        r = d;
    end
    
    actuators.tau1 = u + kRef*r;
end
