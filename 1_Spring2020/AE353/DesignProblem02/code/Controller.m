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
data.tau_max = 100;
syms tau theta zeta thetadot zetadot real
f = parameters.symEOM.f;

x = [zeta; zetadot; theta; thetadot];
xdot = [zetadot; f(1); thetadot; f(2)];
u = [tau];

theta_e = 0;
zeta_e = 0;
thetadot_e = 0;
zetadot_e = 0;
tau_e = 0;

% Double turns the symbolic expression into a floating point matrix
data.A = double(subs(jacobian(xdot, x), [zeta; theta; zetadot; thetadot; tau], [zeta_e; theta_e; zetadot_e; thetadot_e; tau_e]));
data.B = double(subs(jacobian(xdot, u), [zeta; theta; zetadot; thetadot; tau], [zeta_e; theta_e; zetadot_e; thetadot_e; tau_e]));
data.C = [1 0 0 0];
    
Q = diag([25, 5, 25, 5]);
R = diag([10]);
[K, P] = lqr(data.A, data.B, Q, R);
data.K = K;
data.kRef = -1/(data.C*inv(data.A - data.B * data.K)*data.B);
syms t_s real
data.step_function = 3*sin(t_s/5);
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators, data] = runControlSystem(sensors, references, parameters, data)
% Use the state-space model for control
x = [sensors.zeta; sensors.zetadot; sensors.theta; sensors.thetadot];
r1 = 3*sin(sensors.t/5);
r = [double(r1); 0; 0; 0];
u = -data.K * x + data.kRef * r;
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







