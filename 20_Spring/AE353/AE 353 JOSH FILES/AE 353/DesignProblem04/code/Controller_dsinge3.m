function func = Controller
% INTERFACE
%
%   sensors
%       .e_lateral      (error in lateral position relative to road)
%       .e_heading      (error in heading relative to road)
%       .v              (forward speed)
%       .w              (turning rate)
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
%       .symEOM     (nonlinear EOMs in symbolic form)
%       .numEOM     (nonlinear EOMs in numeric form)
%
%   data
%       .whatever   (yours to define - put whatever you want into "data")
%
%   actuators
%       .tauR       (right wheel torque)
%       .tauL       (left wheel torque)

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
data.A = [0 1 0 0 0 0;27.4427195070066 0 0 0 0 0;-3.45398109505311 0 0 0 0 0;0 0 0 0 0 0;0 0 0 0 0 -4;0 0 0 1 0 0];
data.B = [0 0;-2.22551849308104 -2.22551849308104;0.587386021655831 0.587386021655831;2.48138115237663 -2.48138115237663;0 0;0 0];
data.C = [0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1];
data.L = [-106.339118967993 -9.27514911731802e-15 3.78028191472656e-14 -3.79088285699663e-14;-537.743732867303 -4.56099598842174e-14 1.68989130945164e-13 -2.08581095044058e-13;39.1738000857731 4.07992470372096e-15 -5.95594565050935e-15 2.8631214790237e-15;4.07992470372096e-15 28.2798487668845 -0.0176895155687031 0.499840777830277;-5.95594565050935e-15 -0.0176895155687031 28.4949555423531 -1.99072258750505;2.8631214790237e-15 0.499840777830277 -1.99072258750505 28.2274133482343];
data.K = [-13.7367884862554 -3.1374297202358 -0.707106781186542 13.8023243230953 -15.8113883008419 44.6751751492137;-13.7367884862554 -3.1374297202358 -0.707106781186532 -13.8023243230953 15.8113883008419 -44.6751751492138];
data.e = [0;0;4;0;0;0;0;0];
data.xhat=zeros(6,1);
data.xhat(3,1)=-4;
[actuators,data] = runControlSystem(sensors,references,parameters,data);
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors,references,parameters,data)
u = -data.K*data.xhat;
dt = parameters.tStep;

y1 = sensors.v -data.e(3);
y2 = sensors.w -data.e(4);
y3 = sensors.e_lateral-data.e(7);
y4 = sensors.e_heading-data.e(8);
y = [y1;y2;y3;y4];

xhat_dot = data.A*data.xhat+data.B*u-data.L*(data.C*data.xhat-(y));
data.xhat = data.xhat + xhat_dot*dt;

actuators.tauR = u(1)+data.e(5);
actuators.tauL = u(2)+data.e(6);
end