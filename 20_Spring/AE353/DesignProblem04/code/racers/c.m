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

data.A = [0 -2.5 0 0 0 0;0 0 0 0 0 1;0 0 0 1 0 0;0 0 31.4640791188103 0 0 0;0 0 -3.8034582320719 0 0 0;0 0 0 0 0 0];
data.B = [0 0;0 0;0 0;-2.79183447520963 -2.79183447520963;0.665398994051812 0.665398994051812;2.55852693193163 -2.55852693193163];
data.C = [-1 0 0 0 0 0;1 0 0 0 0 0;0 0 0 0 5 1;0 0 0 0 5 -1];
data.K = [-2.49999999999999 4.95023211962056 -199.790222931925 -9.08546252722208 -2.44948974278323 1.56038384304986;2.49999999999999 -4.95023211962056 -199.790222931925 -9.08546252722209 -2.44948974278327 -1.56038384304986];
data.L = [-3.03458928723166 3.03458928723166 -0.0943541368152625 0.0943541368152643;2.43198150690176 -2.43198150690176 0.396640221744703 -0.396640221744704;-2.41771632661821e-15 2.35874359496838e-15 -3.67057569702909 -3.67057569702908;-1.326606336064e-14 1.26299960049193e-14 -20.7500648530926 -20.7500648530926;9.04713886195702e-16 -8.33380453895745e-16 1.79132435279832 1.79132435279832;0.754833094522114 -0.754833094522111 2.2200852179425 -2.22008521794249];
data.xhat = [0;0;0;0;-2.5;0];
data.x_e = [0;0;0;0;2.5;0;0;0];  
data.y_e = [1.3;1.3;12.5;12.5];

data.tau_max = parameters.tauMax;
data.d_max = 3;
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors,references,parameters,data)
y = [sensors.dR; sensors.dL; sensors.wR; sensors.wL] - data.y_e;

% Bound the sensor measurements
if sensors.dL > data.d_max
    sensors.dL = data.d_max;
end
if sensors.dR > data.d_max
    sensors.dR = data.d_max;
end

u = -data.K*data.xhat;
data.xhat = data.xhat + (data.A*data.xhat + data.B*u - data.L*(data.C*data.xhat - y))*parameters.tStep;

% Limit the torque applied to the wheel
tauR = u(1);
tauL = u(2);
if tauR < -data.tau_max
    tauR = -data.tau_max;
elseif tauR > data.tau_max
    tauR = data.tau_max;
end
if tauL < -data.tau_max
    tauL = -data.tau_max;
elseif tauL > data.tau_max
    tauL = data.tau_max;
end

actuators.tauR = tauR;
actuators.tauL = tauL;
end