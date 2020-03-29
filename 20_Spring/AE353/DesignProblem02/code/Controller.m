function func = Controller
% INTERFACE
%
%   sensors
%       .t          (time)
%       .zeta       (horizontal position of wheel center)
%       .theta      (angle of body with respect to vertical)
%       .zetadot    (horizontal linear velocity of wheel)
%       .thetadot   (angular velocity of body)
%
%   references
%       .zeta       (desired horizontal position of wheel center)
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
%       .tau        (torque applied by wheel to body)

% Do not modify this function.
func.init = @initControlSystem;
func.run = @runControlSystem;
end

%
% STEP #1: Modify, but do NOT rename, this function. It is called once,
% before the simulation loop starts.
%

function [data] = initControlSystem(parameters, data)
data.tau_max = 2;
syms tau theta zeta thetadot zetadot real
f = parameters.symEOM.f;

x = [zeta; zetadot; theta; thetadot];
xdot = [zetadot; f(1); thetadot; f(2)];
u = [tau];

data.theta_e = 0;
data.zeta_e = 0;
data.thetadot_e = 0;
data.zetadot_e = 0;
data.tau_e = 0;

% Double turns the symbolic expression into a floating point matrix
data.A = double(subs(jacobian(xdot, x), [zeta; theta; zetadot; thetadot; tau], [data.zeta_e; data.theta_e; data.zetadot_e; data.thetadot_e; data.tau_e]));
data.B = double(subs(jacobian(xdot, u), [zeta; theta; zetadot; thetadot; tau], [data.zeta_e; data.theta_e; data.zetadot_e; data.thetadot_e; data.tau_e]));
data.C = [1 0 0 0];
    
Q = diag([25, 20, 15, 5]);
R = diag([.1]);
[K, P] = lqr(data.A, data.B, Q, R);
data.K = K;
data.kRef = -1/(data.C*inv(data.A - data.B * data.K)*data.B);
data.kInt = -5;
data.error_threshold = 1.5;
syms t_s real
data.step_function = 2*sin(t_s/10);
data.total_zeta_error = 0;
data.zeta_error_cummulative = [];
data.v = 0;
data.loop_count = 0;

end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators, data] = runControlSystem(sensors, references, parameters, data)
syms t_s real

% Use the state-space model for control
x = [sensors.zeta; sensors.zetadot; sensors.theta; sensors.thetadot];
r = [double(vpa(subs(data.step_function, t_s, sensors.t))); 0; 0; 0];
y = data.C * x;

data.v = data.v + parameters.tStep * (y-r);
u = -data.K * x + data.kRef * r - data.kInt * data.v;

% Set the torque applied to the wheel
tau = u(1);
if tau < -data.tau_max
    tau = -data.tau_max;
end
if tau > data.tau_max
    tau = data.tau_max;
end
actuators.tau = tau;
end







