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

function [data] = initControlSystem(sensors, references, parameters,data)
%% State Space Model -- Linearization:
load('DesignProblem04_EOMs.mat');
% Parse the equations of motion.
f = symEOM.f;
% Define symbolic variables that appear in the equations of motion.
syms phi phidot v w tauR tauL elateral eheading

p = [phidot, phi v w elateral eheading tauR tauL];
f_numeric = matlabFunction(f, 'vars', {p})

p_guess = [1 0 1 0 1 0 1 0];
f_numeric_at_v_guess = f_numeric(p_guess)

% With default options
[p_sol, f_numeric_at_v_sol, exitflag] = fsolve(f_numeric, p_guess)

%Choose State
vRoad = 10;
wRoad = 0;
fsym=[f; phidot; -v*sin(eheading); w-((v*cos(eheading))/(vRoad+wRoad*elateral))*wRoad];

%Equilibrium Points
xhat = [0; 0; 0; 0; 0; 0];
eqState = [p_sol(1); p_sol(2); p_sol(3); p_sol(4); p_sol(5); p_sol(6)];
eqInput = [p_sol(7); p_sol(8)];
state = [phidot; v; w; phi; elateral;eheading];
input = [tauR; tauL];
output = [elateral; eheading];

%Linearization
A = double(vpa(subs(jacobian(fsym,state),[state; input],[eqState; eqInput])));
B = double(vpa(subs(jacobian(fsym,input),[state; input],[eqState; eqInput])));
C = double(vpa(jacobian(output, state))); C = [zeros(3,6); C];

controllability = cond(ctrb(A,B))
observability = cond(obsv(A,C))

%% Controller Gains:
Qc = eye(6);
Rc = eye(2);

K = lqr(A, B, Qc, Rc);
% ControllerStability = eig(A-B*K)
% ControllerControllability = rank(ctrb(A,B)) - length(A)

%% Observer Gains:
Qo = eye(5);
Ro = eye(6);

L = lqr(A', C', inv(Ro), inv(Qo))';
% ObserverStability = eig(A-L*C)
% ObserverObservability = rank(ctrb(A,C)) - length(A)


%% Save Values for Simulaton:
data.A = A;
data.B = B;
data.C = C;
data.K = K;
data.L = L;
data.equiState = eqState;
data.equiInput = eqInput;
data.xhat = xhat;
end

%
% STEP #2: Modify, but do NOT rename, this function. It is called every
% time through the simulation loop.
%

function [actuators,data] = runControlSystem(sensors,references,parameters,data)
%% Assign Variables
A = data.A; B = data.B; C = data.C; K = data.K; L = data.L; h = parameters.tStep; xhat = data.xhat; equiState = data.equiState; equiInput = data.equiInput;
sensors.v = (2*pi*(sensors.wR + sensors.wL)) / 2;
sensors.w = (sensors.wR + sensors.wL) / 2;
values = [sensors.v; sensors.w; 0; sensors.e_lateral; sensors.e_heading];

%% Output
y = values - C*[equiState];
%% Input
u = -K*xhat;
%% Observer Design
xhatDot = A*xhat + B*u - L*(C*xhat-y);
data.xhat = xhat + h*xhatDot;

%% Controller
actuators.tauL = u(1);
actuators.tauR = u(2);
end