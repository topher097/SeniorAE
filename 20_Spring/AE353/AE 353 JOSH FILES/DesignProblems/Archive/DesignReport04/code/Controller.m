function func = Controller
% INTERFACE
%
%   sensors
%       .e_lateral      (error in lateral position relative to road)
%       .e_heading      (error in heading relative to road)
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
%       .symEOM     (nonlinear EOMs in symbolic form)
%       .numEOM     (nonlinear EOMs in numeric form)
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
%% Linearization
% Load Equations of motion:
load('DesignProblem04_EOMs.mat');
f = symEOM.f;
% Define symbolic variables to appear in EoM's:
syms phi phidot v w tauR tauL elateral eheading r_road v_road real

w_road = v_road / r_road;
elateralDot = -v*sin(eheading);
eheadingDot = w-((v*cos(eheading))/(v_road+w_road*elateral))*w_road;

F = [f; phidot; elateralDot; eheadingDot];
p = [phidot; v; w; phi; elateral; eheading; tauR; tauL; r_road; v_road];

f_numeric = matlabFunction(F, 'vars', {p});
%% GUESS EQUILIBRIUM POINTS
p_guess = [0; 3; 0; 0; 0; 0; 0; 0; Inf; 2];
%% 
f_numeric_at_p_guess = f_numeric(p_guess);

% With default options
[p_sol, f_numeric_at_p_sol, exitflag] = fsolve(f_numeric, p_guess)

% With non-default options (specify algorithm to avoid MATLAB warning,
% specify very small tolerances to get better accuracy)
options = optimoptions(...
    'fsolve', 'display', 'off', ...                           % name of solver
    'algorithm', 'levenberg-marquardt', ... % algorithm to use
    'functiontolerance', 1e-8, ...         % smaller means higher accuracy
    'steptolerance', 1e-8);                % smaller means higher accuracy
[p_sol, f_numeric_at_p_sol, exitflag] = fsolve(f_numeric, p_guess, options)

r = parameters.r;
b = parameters.b;

wR = (v + w*b/2) / r;
wL = (v - w*b/2) / r;

% Equilibrium Points
phidotE = p_sol(1); vE = p_sol(2); wE = p_sol(3); phiE = p_sol(4); elateralE = p_sol(5);
eheadingE = p_sol(6); tauRE = p_sol(7); tauLE = p_sol(8); r_roadE = p_sol(9); v_roadE = p_sol(10);

data.xhat = [0; -vE; 0; 0; 0; 0];
eqState = [phidotE; vE; wE; phiE; elateralE; eheadingE];
eqInput = [tauRE; tauLE];
eqOutput = [elateralE; eheadingE; vE/r; vE/r];

% State Definitions
xD = [f; phidot; elateralDot; eheadingDot];
state = [phidot; v; w; phi; elateral; eheading];
input = [tauR; tauL];
output = [elateral; eheading; wR; wL];

% Linearization
A = double(vpa(subs(jacobian(xD, state), [state; input; v_road; r_road], [eqState; eqInput; v_roadE; r_roadE])));
B = double(vpa(subs(jacobian(xD, input), [state; input], [eqState; eqInput])));
C = double(vpa(jacobian(output, state)));

%% Controller Gain
Qc = 6*eye(6);
Rc = eye(2);

K = lqr(A, B, Qc, Rc);

%% Observer Gain
Qo = 30*eye(4);
Ro = eye(6);

L = lqr(A', C', inv(Ro), inv(Qo))';

%% Store values:
data.A = A;
data.B = B;
data.C = C;
data.K = K;
data.L = L;
data.tauRE = tauRE;
data.tauLE = tauLE;
data.equiState = eqState;
data.equiInput = eqInput;
data.equiOutput = eqOutput;
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors,references,parameters,data)
%% Load values:
A = data.A;
B = data.B;
C = data.C;
K = data.K;
L = data.L;
tauRE = data.tauRE;
tauLE = data.tauLE;
h = parameters.tStep;
eqState = data.equiState;
eqInput = data.equiInput;
eqOutput = data.equiOutput;


%% Output
y = [sensors.e_lateral;sensors.e_heading;sensors.wR;sensors.wL]-[0; 0; eqOutput(3); eqOutput(4)];
%% Input
u = -K*data.xhat;
xhatdot = A*data.xhat + B*u - L*(C*data.xhat - y);
data.xhat = data.xhat + h*xhatdot;

actuators.tauR = u(1)+tauRE;
actuators.tauL = u(2)+tauLE;
end