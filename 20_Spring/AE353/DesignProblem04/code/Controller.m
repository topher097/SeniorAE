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
data.kRef = z.kRef;
data.kInt = .1*ones(2,4);
data.v_road = z.v_road;
data.b_wheel = z.bm;
data.r_wheel = z.rm;

data.t = 0;
data.v = 0;
data.w = 0;
data.r = 0;
data.tau_max = parameters.tauMax;
data.r_error_interp = 0;
data.curr_r_road = Inf;
data.r_error = 0;
data.r_lim = 10;
data.d_max = 2;
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors,references,parameters,data)
y = [sensors.dR; sensors.dL; sensors.wR; sensors.wL] - data.y_e;
%disp(sensors.r_road)
%disp(y);

% Bound the sensor measurements
if sensors.dL > data.d_max
    sensors.dL = data.d_max;
end
if sensors.dR > data.d_max
    sensors.dR = data.d_max;
end

% Define ramping function
w = 7.5*log10(data.t+1);
if w <= data.y_e(3)
    data.r = [1.3 1.3 w w];
else
    % Set wheel angular velocity to the road angular velocity
    if sensors.r_road ~= Inf
        w_road = data.v_road/sensors.r_road;
        wR = data.y_e(3) + w_road;
        wL = data.y_e(4) - w_road;
    else
        wR = data.y_e(3);
        wL = data.y_e(4);
    end
    data.r = [1.3 1.3 wR wL];
end

u = -data.K*data.xhat + (data.r*data.kRef)';
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

data.t = data.t + parameters.tStep;
end