function func = Controller
% INTERFACE
%
%   sensors
%       .t          (time)
%       .theta      (pitch angle)
%       .phi        (elevator angle)
%
%   references
%       .theta      (reference pitch angle)
%
%   parameters
%       .tStep      (time step)
%       .phidotMax  (maximum elevator angular velocity)  
%       .symEOM     (nonlinear EOMs in symbolic form)
%       .numEOM     (nonlinear EOMs in numeric form)
%
%   data
%       .stuff   (yours to define - put whatever you want into "data")
%
%   actuators
%       .phidot     (elevator angular velocity)

% Do not modify this function.
func.init = @initControlSystem;
func.run = @runControlSystem;
end

%
% STEP #1: Modify, but do NOT rename, this function. It is called once,
% before the simulation loop starts.
%

function [data] = initControlSystem(parameters,data)
data.A = [0 0 0 0 1;0 0 0 0 0;-8.88660441709089 0.637170038304873 -0.037126576781902 -0.19467530397257 0.102815179116037;69.4288684425082 14.1414897498555 1.88573171291284 -15.3473524253102 0.535566776199289;-21.1238796197645 -35.336884407966 0.84931889978391 4.45345176667752 -2.35203143634357];
data.B = [0;1;-0.0164536020701669;-0.150928378298509;0.376397626024605];
data.C = [1, 0, 0, 0, 0; 0, 1, 0, 0, 0; 0, 0, 0, 0, 0; 0, 0, 0, 0, 0; 0, 0, 0, 0, 0];
data.mhat = zeros(5, 1);
data.u = 0;

qC = eye(5);
rC = eye(1);
qO = eye(1);
rO = eye(5);

data.K = lqr(data.A, data.B, 25*qC, rC);
data.L = lqr(data.A', data.C', inv(rO), inv(30*qO))';

end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors, references, parameters, data)
n = [sensors.theta-(0.2355); sensors.phi-deg2rad(1); 0;0;0];
u = -data.K*data.mhat;
data.mhat = data.mhat + (data.A*data.mhat + data.B*u - data.L*(data.C*data.mhat - n))*parameters.tStep;
actuators.phidot = u;
end
