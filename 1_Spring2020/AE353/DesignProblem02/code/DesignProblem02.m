function DesignProblem02(controller,varargin)
% DesignProblem02   run simulation of 2D segway
%
%   DesignProblem02('FunctionName') uses the controller defined by
%       the function 'FunctionName' - for example, in a file with
%       the name FunctionName.m - in the simulation.
%
%   DesignProblem02('FunctionName','P1',V1,'P2','V2',...) optionally
%       defines a number of parameter values:
%
%           'team' : a name (e.g., 'FirstName LastName') that, if defined,
%                    will appear on the figure window
%
%           'datafile' : a filename (e.g., 'data.mat') where, if defined,
%                        data will be logged and saved
%
%           'moviefile' : a filename (e.g., 'movie.mp4') where, if defined,
%                         a movie of the simulation will be saved
%
%           'snapshotfile' : a filename (e.g., 'snap.pdf') where, if
%                            defined, a PDF with a snapshot of the last
%                            frame of the simulation will be saved
%
%           'eomfile' : a filename (e.g., 'eoms.mat') where, if defined,
%                       the EOMs will be saved
%
%           'controllerdatatolog' : a cell array (e.g., {'y','xhat'}) with
%                                   the names of fields in controller.data -
%                                   if 'datafile' is defined (so data is
%                                   logged), then values in these fields will
%                                   also be logged and saved
%
%           'diagnostics' : a flag - true or false (default) that, if true,
%                           will show plots of state and actuator values
%
%           'tStop' : the time at which the simulation will stop (a
%                     positive number) - default value is 30
%
%           'flatground' : a flag - true or false (default) that, if true,
%                          will make the ground flat - this can be helpful
%                          when you first start testing your controller
%
%           'reference' : a function of time that specifies a reference
%                         value of zeta - for example, the following choice
%                         would specify a reference value zeta(t) = sin(t):
%                           @(t) sin(t)
%
%           'initial' : a 4x1 matrix
%                           [zeta, theta, zetadot, thetadot]
%                       that specifies initial values - by default, these
%                       values are:
%                           a + b.*randn(4,1)
%                       where
%                           a = [0; 0; 0; 0]
%                           b = 0.05 * [1; 1; 1; 1]
%
%           'display' : a flag...
%
%                       - If true, it will clear the current figure and
%                         will show the simulation. To quite, type 'q' when
%                         this figure is in the foreground.
%
%                       - If false, it will not show any graphics and will
%                         run the simulation as fast as possible (not in
%                         real-time).

% Parse the arguments
% - Create input parser
p = inputParser;
% - Parameter names must be specified in full
p.PartialMatching = false;
% - This argument is required, and must be first
addRequired(p,'controller',@ischar);
% - These parameters are optional, and can be in any order
addParameter(p,'team',[],@ischar);
addParameter(p,'datafile',[],@ischar);
addParameter(p,'moviefile',[],@ischar);
addParameter(p,'snapshotfile',[],@ischar);
addParameter(p,'eomfile',[],@ischar);
addParameter(p,'controllerdatatolog',[],@iscell);
addParameter(p,'diagnostics',false,@islogical);
addParameter(p,'tStop',30,@(x) isscalar(x) && isnumeric(x) && (x>0));
addParameter(p,'flatground',false,@islogical);
addParameter(p,'reference',@(x)0,@(x) isa(x,'function_handle'));
addParameter(p,'initial',max(min(zeros(4,1)+0.05*ones(4,1).*randn(4,1), 10), -10),...
                         @(x) validateattributes(x,{'numeric'},{'size',[4 1]}));
addParameter(p,'display',true,@islogical);
% - Apply input parser
parse(p,controller,varargin{:});
% - Extract parameters
process = p.Results;
% - Check that the 'controller' function exists
if (exist(process.controller,'file')~=2)
    error('Controller ''%s'' does not exist.',process.controller);
end
% - Check display
if ~process.display && ~isempty(process.moviefile)
    error('You cannot ask to save a movie with the display turned off.');
end
if ~process.display && ~isempty(process.snapshotfile)
    error('You cannot ask to save a snapshot with the display turned off.');
end
% - Enable all warnings
warning('on');
% - Check initial conditions
if abs(process.initial(1)) >= 10
    error('initial value of zeta must be in the interval (-10, 10)');
end
if abs(process.initial(2)) >= 10
    error('initial value of theta must be in the interval (-10, 10)');
end

% Setup the simulation
[process,controller] = SetupSimulation(process);

% Run the simulation
RunSimulation(process,controller);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% FUNCTIONS THAT WILL CHANGE FOR DIFFERENT PROCESSES
%

function [symEOM, numEOM] = GetModelEOM(l1, l2, m1, m2, I1, I2, g, b)

[symEOM_GeneralizedCoordinates, ~] = GetTrueEOM(l1, l2, m1, m2, I1, I2, g, b, 0, 0);

syms q1 q2 real
syms q1d q2d real
syms tau real

syms zeta theta real
syms zetadot thetadot real

r = l1;

q1dd = symEOM_GeneralizedCoordinates.f(1);
q2dd = symEOM_GeneralizedCoordinates.f(2);

f = [-r * q1dd; q1dd + q2dd];
f = subs(f, [q1, q2, q1d, q2d], [-zeta / r, theta + (zeta / r), -zetadot / r, thetadot + (zetadot / r)]);
f = simplify(f);

symEOM.f = f;
numEOM.f = matlabFunction(f, 'Vars', [zeta, zetadot, theta, thetadot, tau]);

end

function [symEOM, numEOM] = GetTrueEOM(l1, l2, m1, m2, I1, I2, g, b, h0, w)

syms q1 q2 real
syms q1d q2d real
syms q1dd q2dd real
syms tau real

r = l1;
l = l2;
s = -r * q1;
x0 = 0;
y0 = 0;

x = x0 + s * mysinc(w * s / 2) * cos(h0 + (w * s / 2));
y = y0 + s * mysinc(w * s / 2) * sin(h0 + (w * s / 2));
h = h0 + w * s;

p0 = [x; y];
p1 = p0 + [-r * sin(h); r * cos(h)];
p2 = p1 + [-l * sin(q1 + q2); l * cos(q1 + q2)];

v1 = diff(p1, q1) * q1d + diff(p1, q2) * q2d;
v2 = diff(p2, q1) * q1d + diff(p2, q2) * q2d;

w1 = q1d;
w2 = q1d + q2d;

T = 0.5*m1*(v1'*v1) + 0.5*m2*(v2'*v2) + 0.5*I1*w1^2 + 0.5*I2*w2^2;
V = m1*g*p1(2) + m2*g*p2(2);
L = simplify(T - V);

q = [q1; q2];
qd = [q1d; q2d];
qdd = [q1dd; q2dd];
f = simplify(diff_t(gradient(L, qd), [q;qd], [qd;qdd]) - gradient(L, q));
f = f - ([0; tau] - [0; b * q2d]);
sol = solve(f(1), f(2), q1dd, q2dd);
f = [sol.q1dd; sol.q2dd];

symEOM.f = f;
numEOM.f = matlabFunction(f, 'Vars', [q1, q1d, q2, q2d, tau]);
numEOM.p0 = matlabFunction(p0, 'Vars', [q1]);
numEOM.p1 = matlabFunction(p1, 'Vars', [q1]);
numEOM.v1 = matlabFunction(v1, 'Vars', [q1, q1d]);
numEOM.p2 = matlabFunction(p2, 'Vars', [q1, q2]);

end

function [q1, q2, q1d, q2d] = GetIC(process)
maxiters = 50;
tol = 1e-12;
zeta_err = @(q1) ([1 0] * process.trueNumEOM.p1(q1)) - process.zeta;
q1bnds = [-10 10] * process.l1;
iters = 0;
while (1)
    iters = iters + 1;
    if iters > maxiters
        error('bad initial conditions (zeta) - try again');
    end
    if (q1bnds(2) - q1bnds(1)) < tol
        break
    end
    q1 = mean(q1bnds);
    if zeta_err(q1) > 0
        q1bnds(1) = q1;
    else
        q1bnds(2) = q1;
    end
end
zetadot_err = @(q1d) ([1 0] * process.trueNumEOM.v1(q1, q1d)) - process.zetadot;
q1dbnds = [-10 10] * process.l1;
iters = 0;
while (1)
    iters = iters + 1;
    if iters > maxiters
        error('bad initial conditions (zetadot) - try again');
    end
    if (q1dbnds(2) - q1dbnds(1)) < tol
        break
    end
    q1d = mean(q1dbnds);
    if zetadot_err(q1d) > 0
        q1dbnds(1) = q1d;
    else
        q1dbnds(2) = q1d;
    end
end
q2 = process.theta - q1;
q2d = process.thetadot;
end

function d = diff_t(f, v, vd)
d = 0;
for i=1:length(v)
    d = d + diff(f, v(i)) * vd(i);
end
d = simplify(d);
end

% Returns sin(x)/x (MATLAB defines "sinc" slightly differently).
function y=mysinc(x)
y = sinc(x/pi);
end

function [process,controller] = SetupSimulation(process)

% DEFINE CONSTANTS

% Constants related to simulation.
% - State time.
process.tStart = 0;
% - Time step.
process.tStep = 1/50;
% - Names of things to log in datafile, if desired
process.processdatatolog = {'t', 'zeta', 'theta', 'zetadot', 'thetadot'};

% Constants related to physical properties.
% - Acceleration of gravity
process.g = 9.81;
% - Wheel
rho = 1.0;                                              % density
process.l1 = 1;                                         % radius
process.d1 = 0.1;                                       % depth
process.m1 = rho * pi * process.l1^2 * process.d1;      % mass
process.J1 = (1 / 2) * process.m1 * process.l1^2;       % moment of inertia
% - Body
rho = 1.0;                                                                  % density
process.l2 = 2;                                                             % half-length
process.e2 = 0.3;                                                           % extra length
process.w2 = 0.5;                                                           % width
process.d2 = 0.1;                                                           % depth
process.m2 = rho * (2*(process.l2 + process.e2) * process.w2 * process.d2);             % mass
process.J2 = (1 / 12) * process.m2 * ((2*(process.l2 + process.e2))^2 + process.w2^2);  % moment of inertia
% - Coefficient of viscuous friction
process.b = 0.1;
% - Maximum torque of motor
process.taumax = 2;
% - Shape of ground
if (process.flatground)
    process.h0 = 0;
    process.w = 0;
else
    process.h0 = 0.1 * pi * (-1 + 2 * rand);
    process.w = 0.005 + 0.015 * rand;
    if rand > 0.5
        process.w = -process.w;
    end
end
% - EOM
[symEOM, numEOM] = GetModelEOM( process.l1, process.l2,...
                                process.m1, process.m2,...
                                process.J1, process.J2,...
                                process.g, ...
                                process.b);
if ~isempty(process.eomfile)
    save(process.eomfile, 'symEOM', 'numEOM');
end
process.symEOM = symEOM;
process.numEOM = numEOM;
% - True EOM
[symEOM, numEOM] = GetTrueEOM(  process.l1, process.l2,...
                                process.m1, process.m2,...
                                process.J1, process.J2,...
                                process.g, ...
                                process.b, ...
                                process.h0, process.w);
process.trueSymEOM = symEOM;
process.trueNumEOM = numEOM;

% DEFINE VARIABLES

% Time
process.t = 0;
% Position and velocity of wheel
process.zeta = process.initial(1, 1);
process.zetadot = process.initial(3, 1);
% Angle and angular velocity of body
process.theta = process.initial(2, 1);
process.thetadot = process.initial(4, 1);
% Generalized coordinates
[process.q1, process.q2, process.q1d, process.q2d] = GetIC(process);

% DEFINE CONTROLLER

% Functions
% - get handles to user-defined functions 'init' and 'run'
controller = eval(process.controller);
controller.name = process.controller;
% Parameters
% - define a list of constants that will be passed to the controller
names = {'tStep', 'taumax', 'symEOM', 'numEOM'};
% - loop to create a structure with only these constants
controller.parameters = struct;
for i=1:length(names)
    controller.parameters.(names{i}) = process.(names{i});
end
% Storage
controller.data = struct;
% Status
controller.running = true;
% Init
tic
try
    [controller.data] = ...
        controller.init(controller.parameters, ...
                        controller.data);
catch exception
    warning(['The ''init'' function of controller\n     ''%s''\n' ...
             'threw the following error:\n\n' ...
             '==========================\n' ...
             '%s\n', ...
             '==========================\n\n' ...
             'Turning off controller and setting all\n' ...
             'actuator values to zero.\n'],controller.name,getReport(exception));
	controller.actuators = ZeroActuators();
    controller.running = false;
end
controller.tInit = toc;
% Get reference values
controller.references = GetReferences(process);
% Get sensor values
controller.sensors = GetSensors(process);
% Get actuator values (run controller)
controller = RunController(controller);
end

function controller = RunController(controller)
if (controller.running)
    tic
    try
        [controller.actuators,controller.data] = ...
            controller.run(controller.sensors, ...
                              controller.references, ...
                              controller.parameters, ...
                              controller.data);
    catch exception
        warning(['The ''run'' function of controller\n     ''%s''\n' ...
                 'threw the following error:\n\n' ...
                 '==========================\n' ...
                 '%s\n', ...
                 '==========================\n\n' ...
                 'Turning off controller and setting all\n' ...
                 'actuator values to zero.\n'],controller.name,getReport(exception));
        controller.actuators = ZeroActuators();
        controller.running = false;
    end
    if (~isstruct(controller.actuators) || ~CheckActuators(controller.actuators))
        warning(['The ''run'' function of controller\n     ''%s''\n' ...
                 'did not return a structure ''actuators'' with the right\n' ...
                 'format. Turning off controller and setting all\n' ...
                 'actuator values to zero.\n'],controller.name);
        controller.actuators = ZeroActuators();
        controller.running = false;
    end
    controller.tRun = toc;
else
    controller.tRun = 0;
end
end

function references = GetReferences(process)
try
    references = struct('zeta', process.reference(process.t));
catch exception
    warning(['The ''references'' function that was passed to\n' ...
             'DesignProblem01 threw the following error:\n\n' ...
             'threw the following error:\n\n' ...
             '==========================\n' ...
             '%s\n', ...
             '==========================\n\n' ...
             'Leaving references unchanged.\n'],getReport(exception));
    references = struct('zeta', 0);
end
end

function sensors = GetSensors(process)
sensors.t = process.t;
sensors.zeta = [1 0] * process.trueNumEOM.p1(process.q1);
sensors.theta = process.q1 + process.q2;
sensors.zetadot = [1 0] * process.trueNumEOM.v1(process.q1, process.q1d);
sensors.thetadot = process.q1d + process.q2d;
% Add noise
%   (nothing)
end

function [t,x] = Get_TandX_From_Process(process)
t = process.t;
x = [process.q1; process.q2; process.q1d; process.q2d];
end

function u = GetInput(process,actuators)
% Copy input from actuators
u = [actuators.tau];

% Bound input
for i=1:length(u)
    if (u(i) < -process.taumax)
        u(i) = process.taumax;
    elseif (u(i) > process.taumax)
        u(i) = process.taumax;
    end
end

% Add disturbance
%   (nothing)
end

function process = Get_Process_From_TandX(t,x,process)
process.t = t;
process.q1 = x(1,1);
process.q2 = x(2,1);
process.q1d = x(3,1);
process.q2d = x(4,1);
end

function xdot = GetXDot(t,x,u,process)
% unpack x and u
q1 = x(1,1);
q2 = x(2,1);
q1d = x(3,1);
q2d = x(4,1);
tau = u(1,1);
% compute xdot
xdot = [q1d; q2d; process.trueNumEOM.f(q1, q1d, q2, q2d, tau)];
end

function iscorrect = CheckActuators(actuators)
iscorrect = false;
if all(isfield(actuators,{'tau'}))&&(length(fieldnames(actuators))==1)
    if isnumeric(actuators.tau)
        if isscalar(actuators.tau)
            if (~isnan(actuators.tau))&&(~isinf(actuators.tau))
                iscorrect = true;
            end
        end
    end
end
end

function actuators = ZeroActuators()
actuators = struct('tau', 0);
end

function fig = UpdateFigure(process,controller,fig)
if (isempty(fig))
    % CREATE FIGURE
    
    % Clear the current figure.
    clf;
    
    % Create an axis for text (it's important this is in the back,
    % so you can rotate the view and other stuff!)
    fig.text.axis = axes('position',[0 0 1 1]);
    axis([0 1 0 1]);
    hold on;
    axis off;
    fs = 14;
    if (controller.running)
        status = 'ON';
        color = 'g';
    else
        status = 'OFF';
        color = 'r';
    end
    fig.text.status=text(0.05,0.975,...
        sprintf('CONTROLLER: %s',status),...
        'fontweight','bold','fontsize',fs,...
        'color',color,'verticalalignment','top');
    fig.text.time=text(0.05,0.12,...
        sprintf('t = %6.2f / %6.2f\n',process.t,process.tStop),...
        'fontsize',fs,'verticalalignment','top','fontname','monaco');
    fig.text.teamname=text(0.05,0.06,...
        sprintf('%s',process.team),...
        'fontsize',fs,'verticalalignment','top','fontweight','bold');
    
    if process.diagnostics
        fig.x.axis = axes('position',[0.55,0.76,0.4,0.2],'fontsize',fs);
        axis([0,process.tStop,-10,10]);
        hold on;
        fig.x.zeta = plot(nan,nan,'linewidth',2);
        fig.x.ref = plot(nan,nan,':','linewidth',3);
        fig.x.legend = legend({'zeta','zeta (desired)'});
        xlabel('time');
        
        fig.x.axis2 = axes('position',[0.55,0.43,0.4,0.2],'fontsize',fs);
        axis([0,process.tStop,-pi,pi]);
        hold on;
        fig.x.theta = plot(nan,nan,'linewidth',2);
        fig.x.legend = legend({'theta'});
        xlabel('time');

        fig.u.axis = axes('position',[0.55,0.1,0.4,0.2],'fontsize',fs);
        delta = 0.1*process.taumax;
        axis([0,process.tStop,-process.taumax-delta,process.taumax+delta]);
        hold on;
        fig.u.tau = plot(nan,nan,'linewidth',3,'color',[0.4940 0.1840 0.5560]);
        fig.u.umin = plot([0 process.tStop],-process.taumax*[1 1],...
                          'linewidth',1,'linestyle','--','color','k');
        fig.u.umax = plot([0 process.tStop],process.taumax*[1 1],...
                          'linewidth',1,'linestyle','--','color','k');
        fig.u.legend = legend({'tau'});
        xlabel('time');
    end
    
    % Create an axis for the view from frame 0.
    if process.diagnostics
        fig.view0.axis = axes('position',[0 0.15 0.5 0.7]);
        axis equal;
        axis([-10 10 -5 15]);
    else
        fig.view0.axis = axes('position',[0 0.15 1 0.7]);
        axis equal;
        axis([-15 15 -5 10]);
    end
    set(gcf,'renderer','opengl');
    set(gcf,'color','w');
    axis manual;
    hold on;
    axis off;
    box on;
    
    ymin = -50;
    ymax = 50;
    fig.view0.zetades = line([controller.references.zeta, controller.references.zeta], ...
                             [ymin, ymax], 'color', 'r', 'linestyle', ':', 'linewidth', 3);
    q1 = linspace(-20 * process.l1, 20 * process.l1, 100);
    p0 = nan(3, length(q1));
    for i = 1:length(q1)
        p0(:, i) = [process.trueNumEOM.p0(q1(i)); 0];
    end
    fig.geom.pGround_in0 = [p0 [p0(1, end); ymin; 0] [p0(1, 1); ymin; 0] p0(:, 1)];
    fig.view0.ground = fill(fig.geom.pGround_in0(1, :), fig.geom.pGround_in0(2, :), 'g');
    
    o_1in0 = [process.trueNumEOM.p1(process.q1); 0];
    R_1in0 = RZ(process.q1);
    o_2in0 = [process.trueNumEOM.p2(process.q1, process.q2); 0];
    R_2in0 = RZ(process.q1 + process.q2);
    
    theta = linspace(0, 2 * pi, 30);
    fig.geom.pWheel_in1 = process.l1 * [cos(theta); sin(theta); zeros(size(theta))];
    fig.geom.pWheel_in0 = Transform(o_1in0, R_1in0, fig.geom.pWheel_in1);
    fig.view0.wheel = fill(fig.geom.pWheel_in0(1, :), fig.geom.pWheel_in0(2, :), 'y');
    
    theta = [0 pi/2 pi 0];
    fig.geom.pMark_in1 = process.l1 * [cos(theta); sin(theta); zeros(size(theta))];
    fig.geom.pMark_in0 = Transform(o_1in0, R_1in0, fig.geom.pMark_in1);
    fig.view0.mark = fill(fig.geom.pMark_in0(1, :), fig.geom.pMark_in0(2, :), 'k');
    
    dx = 0.5 * process.w2;
    dy = process.l2 + process.e2;
    fig.geom.pBody_in2 = [dx dx -dx -dx dx;
                          -dy dy dy -dy -dy;
                          0 0 0 0 0];
	fig.geom.pBody_in0 = Transform(o_2in0, R_2in0, fig.geom.pBody_in2);
    fig.view0.body = fill(fig.geom.pBody_in0(1, :), fig.geom.pBody_in0(2, :), 'y');
    
    theta = linspace(0, 2 * pi, 30);
    fig.geom.pAxle_in1 = 0.1 * process.l1 * [cos(theta); sin(theta); zeros(size(theta))];
    fig.geom.pAxle_in0 = Transform(o_1in0, R_1in0, fig.geom.pAxle_in1);
    fig.view0.axle = fill(fig.geom.pAxle_in0(1, :), fig.geom.pAxle_in0(2, :), 'k');
    
    % Make the figure respond to key commands.
    set(gcf,'KeyPressFcn',@onkeypress);
end

% UPDATE FIGURE

set(fig.text.time,'string',sprintf('t = %6.2f / %6.2f\n',process.t,process.tStop));
if (controller.running)
    status = 'ON';
    color = 'g';
else
    status = 'OFF';
    color = 'r';
end
set(fig.text.status,'string',sprintf('CONTROLLER: %s',status),'color',color);

o_1in0 = [process.trueNumEOM.p1(process.q1); 0];
R_1in0 = RZ(process.q1);
o_2in0 = [process.trueNumEOM.p2(process.q1, process.q2); 0];
R_2in0 = RZ(process.q1 + process.q2);

if process.diagnostics
    
    t = get(fig.x.zeta,'xdata');
    x = get(fig.x.zeta,'ydata');
    set(fig.x.zeta,'xdata',[t process.t],'ydata',[x, o_1in0(1)]);

    t = get(fig.x.theta,'xdata');
    x = get(fig.x.theta,'ydata');
    set(fig.x.theta,'xdata',[t process.t],'ydata',[x, angdiff(process.q1 + process.q2, 0)]);
    
    t = get(fig.x.ref,'xdata');
    x = get(fig.x.ref,'ydata');
    set(fig.x.ref,'xdata',[t process.t],'ydata',[x controller.references.zeta]);

    t = get(fig.u.tau,'xdata');
    x = get(fig.u.tau,'ydata');
    set(fig.u.tau,'xdata',[t process.t],'ydata',[x controller.actuators.tau]);
    
end

set(fig.view0.zetades, 'xdata', [controller.references.zeta, controller.references.zeta]);

fig.geom.pWheel_in0 = Transform(o_1in0, R_1in0, fig.geom.pWheel_in1);
fig.geom.pMark_in0 = Transform(o_1in0, R_1in0, fig.geom.pMark_in1);
fig.geom.pBody_in0 = Transform(o_2in0, R_2in0, fig.geom.pBody_in2);
fig.geom.pAxle_in0 = Transform(o_1in0, R_1in0, fig.geom.pAxle_in1);

set(fig.view0.wheel, 'xdata', fig.geom.pWheel_in0(1, :), 'ydata', fig.geom.pWheel_in0(2, :));
set(fig.view0.mark, 'xdata', fig.geom.pMark_in0(1, :), 'ydata', fig.geom.pMark_in0(2, :));
set(fig.view0.body, 'xdata', fig.geom.pBody_in0(1, :), 'ydata', fig.geom.pBody_in0(2, :));
set(fig.view0.axle, 'xdata', fig.geom.pAxle_in0(1, :), 'ydata', fig.geom.pAxle_in0(2, :));

% R_Min1 = [1 0 0;
%           0 0 -1;
%           0 1 0];
% o_1in0 = [process.q1; process.q2; 0];
% R_1in0 = [cos(process.q3) -sin(process.q3) 0; sin(process.q3) cos(process.q3) 0; 0 0 1];
% fig.geom.pFrame1_in0 = Transform(o_1in0, R_1in0, fig.geom.pFrame1_in1);
% fig.geom.pRobot_in0 = Transform(o_1in0, R_1in0 * R_Min1, fig.geom.pRobot_in1);
% 
% fig.view0.frame1 = DrawFrame(fig.view0.frame1, fig.geom.pFrame1_in0);
% fig.view0.robot = DrawMesh(fig.view0.robot, fig.geom.pRobot_in0);
    
drawnow;
end

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% FUNCTIONS THAT (I HOPE) WILL REMAIN THE SAME FOR ALL PROCESSES
%

function RunSimulation(process,controller)

% START-UP

% Create empty figure.
fig = [];

% Flag to stop simulation on keypress.
global done
done = false;

% Start making movie, if necessary.
if (~isempty(process.moviefile))
    myV = VideoWriter(process.moviefile,'MPEG-4');
    myV.Quality = 100;
    myV.FrameRate = 1/process.tStep;
    open(myV);
end

% LOOP

% Loop until break.
tStart = tic;
while (1)
    
    % Update figure (create one if fig is empty).
    if (process.display)
        fig = UpdateFigure(process,controller,fig);
    end
    
    % Update data.
    if (~isempty(process.datafile))
        [process,controller] = UpdateDatalog(process,controller);
    end
    
    % If making a movie, store the current figure as a frame.
    if (~isempty(process.moviefile))
        frame = getframe(gcf);
        writeVideo(myV,frame);
    end
    
    % Stop if time has reached its maximum.
    if ((process.t + (process.tStep / 2) >= process.tStop)||done)
        break;
    end
    
    % Update process (integrate equations of motion).
    [process,controller] = UpdateProcess(process,controller);
    
    % Wait if necessary, to stay real-time.
    if (process.display)
        while (toc(tStart)<process.t-process.tStart)
            % Do nothing
        end
    end
    
end

% SHUT-DOWN

% Close and save the movie, if necessary.
if (~isempty(process.moviefile))
    for i=1:myV.FrameRate
        frame = getframe(gcf);
        writeVideo(myV,frame);
    end
    close(myV);
end

% Save the data.
if (~isempty(process.datafile))
    processdata = process.log.process; %#ok<NASGU>
    controllerdata = process.log.controller; %#ok<NASGU>
    save(process.datafile,'processdata','controllerdata');
end

% Save the snapshot, if necessary.
if (~isempty(process.snapshotfile))
    set(gcf,'paperorientation','landscape');
    set(gcf,'paperunits','normalized');
    set(gcf,'paperposition',[0 0 1 1]);
    print(gcf,'-dpdf',process.snapshotfile);
end

end


function [process,controller] = UpdateDatalog(process,controller)
% Create data log if it does not already exist.
if (~isfield(process,'log'))
    process.log = struct('process',struct,...
                         'controller',struct('tInit',[],...
                                             'tRun',[],...
                                             'sensors',struct,...
                                             'actuators',struct,...
                                             'data',struct),...
                         'count',0);
end
% Increment log count.
process.log.count = process.log.count+1;
% Write process data to log.
for i=1:length(process.processdatatolog)
    name = process.processdatatolog{i};
    process.log.process.(name)(:,process.log.count) = process.(name);
end
% Write controller data to log, if controller is running.
if controller.running
    process.log.controller.tInit = controller.tInit;
    process.log.controller.tRun(:,process.log.count) = ...
        controller.tRun;
    names = fieldnames(controller.sensors);
    for i=1:length(names)
        name = names{i};
        process.log.controller.sensors.(name)(:,process.log.count) = ...
            controller.sensors.(name);
    end
    names = fieldnames(controller.actuators);
    for i=1:length(names)
        name = names{i};
        process.log.controller.actuators.(name)(:,process.log.count) = ...
            controller.actuators.(name);
    end
    for i=1:length(process.controllerdatatolog)
        name = process.controllerdatatolog{i};
        try
            process.log.controller.data.(name)(:,process.log.count) = ...
                controller.data.(name);
        catch exception
            warning(['Saving element ''%s'' of data for controller\n',...
                     '     ''%s''',...
                     'threw the following error:\n\n' ...
                     '==========================\n' ...
                     '%s\n', ...
                     '==========================\n\n' ...
                     'Turning off controller and setting all\n' ...
                     'actuator values to zero.\n'],...
                     name,controller.name,getReport(exception));
            controller.actuators = ZeroActuators();
            controller.running = false;
            return
        end
    end
end
end


function [process,controller] = UpdateProcess(process,controller)
% Integrate equations of motion
[t0,x] = Get_TandX_From_Process(process);
u = GetInput(process,controller.actuators);
[t,x] = ode45(@(t,x) GetXDot(t,x,u,process),[t0 t0+process.tStep],x);
process = Get_Process_From_TandX(t(end),x(end,:)',process);
% Get reference values
controller.references = GetReferences(process);
% Get sensor values
controller.sensors = GetSensors(process);
% Get actuator values (run controller)
controller = RunController(controller);
end

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% HELPER FUNCTIONS
%

function p_inj = Transform(o_kinj,R_kinj,p_ink)
p_inj = zeros(size(p_ink));
for i=1:size(p_ink,2)
    p_inj(:,i) = o_kinj + R_kinj*p_ink(:,i);
end
end

function onkeypress(src,event)
global done
if event.Character == 'q'
    done = true;
end
end

function mesh = DrawMesh(mesh,p,f,color,alpha)
if isempty(mesh)
    mesh = patch('Vertices',p','Faces',f,...
                 'FaceColor',color,'FaceAlpha',alpha,'EdgeAlpha',alpha);
else
    set(mesh,'vertices',p');
end
end

function frame = DrawFrame(frame,p)
if isempty(frame)
    frame.x = plot3(p(1,[1 2]),p(2,[1 2]),p(3,[1 2]),'r-','linewidth',2);
    frame.y = plot3(p(1,[1 3]),p(2,[1 3]),p(3,[1 3]),'g-','linewidth',2);
    frame.z = plot3(p(1,[1 4]),p(2,[1 4]),p(3,[1 4]),'b-','linewidth',2);
else
    set(frame.x,'xdata',p(1,[1 2]),'ydata',p(2,[1 2]),'zdata',p(3,[1 2]));
    set(frame.y,'xdata',p(1,[1 3]),'ydata',p(2,[1 3]),'zdata',p(3,[1 3]));
    set(frame.z,'xdata',p(1,[1 4]),'ydata',p(2,[1 4]),'zdata',p(3,[1 4]));
end
end

function R = RZ(h)
R = [cos(h) -sin(h) 0; sin(h) cos(h) 0; 0 0 1];
end

function dh=angdiff(h2,h1)
% Returns the shortest path from h1 to h2.
% (The vector from h1 to h2 in S^1. Note this
%  is NOT always equal to h2-h1.)
dh=mod((h2-h1)+pi,2*pi)-pi;
end

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


