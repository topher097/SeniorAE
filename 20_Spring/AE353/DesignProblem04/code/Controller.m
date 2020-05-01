function func = Controller
% INTERFACE
%
%   sensors
%       .dR             (distance to edge of road off right wheel)
%       .dL             (distance to edge of road off left wheel)
%       .wR             (angular velocity of right wheel)
%       .wL             (angular velocity of left wheel)
%       .r_road         (signed radius of curvature of road - to find the
%                        corresponding turning rate for a given forward
%                        speed: w_road = v_road/sensors.r_road)
%
%   references
%       (none)
%
%   parameters
%       .tStep      (time step)
%       .tauMax     (maximum wheel torque)
%       .roadwidth  (width of road - half on each side of centerline)
%       .b          (distance between the two wheels)
%       .r          (radius of each wheel)
%
%   data
%       .whatever   (yours to define - put whatever you want into "data")
%
%   actuators
%       .tauR       (right wheel torque)
%       .tauL       (left wheel torque)

% Do not modify this part of the function.
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

%
% Here is a good place to initialize things like gains...
%
%   data.K = [1 2 3 4];
%
% ...or like the integral of error in reference tracking...
%
%   data.v = 0;
%

z = load('control.mat');
data.A = z.A; 
data.B = z.B;
data.C = z.C;
data.K = z.K;
data.L = z.L;
data.xhat = z.xhat_guess;
data.x_e = z.equiPoints;
data.y_e = z.y_e;

end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors,references,parameters,data)
%y = [sensors.dL - 1.307934e+00; sensors.dR - 1.292066e+00; sensors.wL - 6.070032e-02; sensors.wR - 1.405778e-01];
y = [sensors.dR; sensors.dL; sensors.wR; sensors.wL] - data.y_e;
u = -data.K*data.xhat;
data.xhat = data.xhat + (data.A*data.xhat + data.B*u - data.L*(data.C*data.xhat - y))*parameters.tStep;
actuators.tauR = u(1);
actuators.tauL = u(2);
end