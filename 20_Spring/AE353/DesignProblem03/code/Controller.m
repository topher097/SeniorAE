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
data.A = [0 0 0 0 1;0 0 0 0 0;-8.76895244751868 0.801329310786424 -0.0158592324641004 -0.171581630248403 0.10070503498306;117.397890043635 23.5660404846262 1.44526650385018 -19.6479780905323 1.08618948686019;-54.9385632583553 -78.543143550386 0.836929536852684 9.05477201777069 -5.31444497574357];
data.B = [0;1;0.0123117527734555;0.19492056432716;-0.649720569388887];
data.C = [0 1 0 0 0;-0.584546909255476 0 0.999988778807882 0.00473732607285412 0];
data.K = [-119.083450114985 34.1539911418645 1.57546764335448 -2.79513502448038 -10.7740769744503];
data.L = [-1.42607413467955 -4.63052529080546;1.54844870560196 1.61316663929043;0.802936656264393 7.66300565877125;-4.93279003898016 -22.1436909907888;-9.67801156945507 -12.9234561143178];
data.xhat = [0.261799387799149;0;0.965925826289068;0.258819045102521;0];


end


function [actuators,data] = runControlSystem(sensors, references, parameters, data)
y = [sensors.phi - -6.781647e-02; sensors.airspeed - 6.013263e+00];
u = -data.K*data.xhat;
%disp(sensors.phi)
data.xhat = data.xhat + (data.A*data.xhat + data.B*u - data.L*(data.C*data.xhat - y))*parameters.tStep;
actuators.phidot = u;
end
