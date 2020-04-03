function func = Controller
% INTERFACE
%
%   sensors
%       .t          (time)
%       .phi        (elevator angle)
%       .airspeed   (airspeed)
%
%   references
%       .theta      (desired pitch angle)
%
%   parameters
%       .tStep      (time step)
%       .phidotMax  (maximum elevator angular velocity)
%
%   data
%       .whatever   (yours to define - put whatever you want into "data")
%
%   actuators
%       .phidot     (elevator angular velocity)

% Do not modify this function.
func.init = @initControlSystem;
func.run = @runControlSystem;
end


function [data] = initControlSystem(parameters,data)
% Define state-space controller matrices
data.A = [0 0 0 0 1;0 0 0 0 0;-9.21283417910763 0.102652979277309 -0.00725631031654261 -0.0986498437309198 0.0516174933172326;117.276262299749 23.5094952594991 1.51950843836173 -19.6383478074267 0.698377236479018;-35.2121360463625 -58.7788271099398 0.42787125999854 5.81692992191461 -3.04364689687122]
data.B = [0;1;-0.00826262705624536;-0.194955777720729;0.48720923496213]
data.C = [1, 0, 0, 0, 0; 0, 1, 0, 0, 0; 0, 0, 0, 0, 0; 0, 0, 0, 0, 0; 0, 0, 0, 0, 0];
data.mhat = zeros(5, 1);
data.u = 0;

qC = eye(5);
rC = eye(1);
qO = eye(1);
rO = eye(5);

qC_mult = 25;
qO_mult = 30;

% Define observer and gain matrices
data.K = lqr(data.A, data.B, qC_mult*qC, rC);
data.L = lqr(data.A', data.C', inv(rO), inv(qO_mult*qO))';

data.x = 0;
data.y = 0;
end


function [actuators,data] = runControlSystem(sensors, references, parameters, data)
theta = 
n = [sensors.theta-(0.2355); sensors.phi-deg2rad(1); 0;0;0];
u = -data.K*data.mhat;
data.mhat = data.mhat + (data.A*data.mhat + data.B*u - data.L*(data.C*data.mhat - n))*parameters.tStep;
actuators.phidot = u;
end
