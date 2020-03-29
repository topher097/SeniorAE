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
%       .whatever   (yours to define - put whatever you want into "data")
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

function [actuators,data] = initControlSystem(sensors,references,parameters,data)

%
% Here is a good place to initialize things like gains...
%
%   data.K = [1 2 3 4];
%
% ...or like the integral of error in reference tracking...
%
%   data.v = 0;
%
data.A = [0 0 0 0 1;0 0 0 0 0;-8.76949567097035 0.801240955642527 -0.00986235870529519 -0.146699230584893 0.0859191082937792;161.39756201802 32.3424530875513 1.23639876581494 -22.9411805305806 1.27593640855818;-75.430159445214 -107.800668332989 0.714960296305049 10.6347912744559 -6.22860648582835];
data.B = [0;1;0.0105038361856483;0.228441754719019;-0.761463468436259];
data.C = [1 0 0 0 0;0 1 0 0 0];
Qc = eye(size(data.A));
Qc(1,1) = 200;
Rc = .1;
Qo = 1*eye(2);
Ro = eye(5);
Ro(1,1) = 100;
data.K = lqr(data.A,data.B,Qc,Rc);
data.L = lqr(data.A',data.C',inv(Ro),inv(Qo))';
%data.xhat = [0;-0.0872665;6;0;0];
data.xhat = [0;0;6;0;0];
disp(mat2str(obsv(data.A,data.C)))
ligma = [data.A-data.B*data.K -data.B*data.K;zeros(size(data.A)) data.A-data.L*data.C];
disp(eig(ligma))
% Do not modify this line.
[actuators,data] = runControlSystem(sensors,references,parameters,data);
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors,references,parameters,data)
u = -data.K*data.xhat;
y = [sensors.theta; sensors.phi];
data.xhat = data.xhat + (data.A*data.xhat + data.B*u - data.L*(data.C*data.xhat - y))*parameters.tStep;
actuators.phidot = u;
end