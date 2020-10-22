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

data.A = [0 -2 0 0 0 0;0 0 0 0 0 1;0 0 0 1 0 0;0 0 31.4640791188103 0 0 0;0 0 -3.8034582320719 0 0 0;0 0 0 0 0 0];
data.B = [0 0;0 0;0 0;-2.79183447520963 -2.79183447520963;0.665398994051812 0.665398994051812;2.55852693193163 -2.55852693193163];
data.C = [0 0 0 0 5 1;0 0 0 0 5 -1;-1 0 0 0 0 0;1 0 0 0 0 0];
data.K = [-1.87082869338695 3.9639169687087 -23.7102722070307 -5.41209502128674 -6.12372435695796 1.43153643258253;1.87082869338696 -3.9639169687087 -23.7102722070307 -5.41209502128675 -6.12372435695797 -1.43153643258253];
data.L = [-0.0152194425884989 0.0152194425884987 -18.7088930796358 18.7088930796358;0.392355388332504 -0.392355388332498 50.0119192112031 -50.0119192112031;-23.7127718868307 -23.7127718868307 -2.56050290230309e-15 2.56050290230309e-15;-127.157019998645 -127.157019998645 -1.41595317419433e-14 1.41595317419433e-14;8.24852153344112 8.24852153344112 6.93361947344142e-17 -6.93361947344142e-17;7.07098591731284 -7.07098591731284 0.076097212942494 -0.076097212942494];
data.kRef = [-2.44948974278317 -2.44948974278319;-2.44948974278317 -2.44948974278319;3.74165738677391 -3.74165738677392;-3.74165738677391 3.74165738677392];
data.xhat = [0;0;0;0;-2;0]; 
data.v_road = 2;
data.r = .2;
data.b = .4;
data.yeq = [10;10;1.3;1.3];
data.wReq = data.yeq(1);
data.wLeq = data.yeq(2);
data.dReq = data.yeq(3);
data.dLeq = data.yeq(4);

end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors,references,parameters,data)


w_road = data.v_road/sensors.r_road;

if sensors.r_road ~= Inf
wr = (data.v_road/data.r) + (((w_road/3)*data.b)/(2*data.r)) - data.wReq;
wl = (data.v_road/data.r) - (((w_road/3)*data.b)/(2*data.r)) -data.wLeq;
else 
    wr = 0;
    wl = 0;
end 

r = [wr wl 0 0] ;
% 
u = -data.K*data.xhat+(r*data.kRef)';

if u(1) > parameters.tauMax
    u(1) = parameters.tauMax;
end 
if u(1) < -parameters.tauMax;
    u(1) = -parameters.tauMax;
end 
if u(2) < -parameters.tauMax;
    u(2) = -parameters.tauMax;
end 
if u(2) > parameters.tauMax;
    u(2) = parameters.tauMax;
end 

actuators.tauR = u(1);
actuators.tauL = u(2);

data.y = [sensors.wR-data.wReq; sensors.wL-data.wLeq; sensors.dR-data.dReq; sensors.dL-data.dLeq];
data.xhat = data.xhat + parameters.tStep*(data.A*data.xhat + data.B*u - data.L*(data.C*data.xhat-data.y));
end