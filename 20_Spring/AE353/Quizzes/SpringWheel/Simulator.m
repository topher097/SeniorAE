function Simulator(controller,varargin)
% Simulator   run simulation of flywheel with spring
%
%   Simulator('FunctionName') uses the controller defined by
%       the function 'FunctionName' - for example, in a file with
%       the name FunctionName.m - in the simulation.
%
%   Simulator('FunctionName','P1',V1,'P2','V2',...) optionally
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
%           'controllerdatatolog' : a cell array (e.g., {'y','xhat'}) with
%                                   the names of fields in controller.data -
%                                   if 'datafile' is defined (so data is
%                                   logged), then values in these fields will
%                                   also be logged and saved
%
%           'diagnostics' : a flag - true (default) or false that, if true,
%                           will show plots of state and actuator values
%
%           'tStop' : the time at which the simulation will stop (a
%                     positive number) - default value is 30
%
%           'reference' : a function of time that specifies a reference
%                         value of d - for example, the following choice
%                         would specify a reference value d(t) = sin(t):
%                           @(t) sin(t)
%
%           'initial' : a 2x1 matrix [psi; psidot] that specifies
%                       initial conditions - by default, these values are:
%                       	[0.1; 0.1].*randn(2,1)
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
addParameter(p,'controllerdatatolog',[],@iscell);
addParameter(p,'diagnostics',true,@islogical);
addParameter(p,'tStop',30,@(x) isscalar(x) && isnumeric(x) && (x>0));
addParameter(p,'reference',@(x)0,@(x) isa(x,'function_handle'));
addParameter(p,'initial',[0.1; 0.1].*randn(2,1),...
                         @(x) validateattributes(x,{'numeric'},{'size',[2 1]}));
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

% Setup the simulation
[process,controller] = SetupSimulation(process);

% Run the simulation
RunSimulation(process,controller);


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% FUNCTIONS THAT WILL CHANGE FOR DIFFERENT PROCESSES
%

function [process,controller] = SetupSimulation(process)

% DEFINE CONSTANTS

% Constants related to simulation.
% - State time.
process.tStart = 0;
% - Time step.
process.tStep = 1/50;
% - Names of things to log in datafile, if desired
process.processdatatolog = {'t','psi','psidot'};

% Constants related to physical properties.
r = 1;
J = 5;
x = 1;
y = 2;
b = 0.2;
k = 5;
process.f = @(psi, psidot, tau) ...
    [psidot;
     (1 / J) * (-b * psidot + k * r * y * cos(psi) - k * r * x * sin(psi) + tau)];
process.r = r;
process.x = x;
process.y = y;
process.tauMax = 21;

% DEFINE VARIABLES

% Time
process.t = 0;
% Initial conditions
process.psi = process.initial(1,1);
process.psidot = process.initial(2,1);

% DEFINE CONTROLLER

% Functions
% - get handles to user-defined functions 'init' and 'run'
controller = eval(process.controller);
controller.name = process.controller;
if isfield(controller,'iDelay')
    process.iDelay = floor(controller.iDelay);
    if (process.iDelay<0)
        process.iDelay = 0;
    end
    fprintf(1,'     controller %s has iDelay=%d\n',controller.name,process.iDelay);
else
    process.iDelay = 0;
end
% Parameters
% - define a list of constants that will be passed to the controller
names = {'tStep','tauMax'};
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
sensors = CreateSensors(process);
for i=0:process.iDelay
    process.sensors_delayed{i+1} = sensors;
end
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
    references = struct('d',process.reference(process.t));
catch exception
    warning(['The ''references'' function that was passed to\n' ...
             'Simulator threw the following error:\n\n' ...
             'threw the following error:\n\n' ...
             '==========================\n' ...
             '%s\n', ...
             '==========================\n\n' ...
             'Leaving references unchanged.\n'],getReport(exception));
    references = struct('d',0);
end
end

function sensors = CreateSensors(process)
sensors.t = process.t;
sensors.d = sqrt((process.x - process.r * cos(process.psi))^2 + (process.y - process.r * sin(process.psi))^2);
end

function process = UpdateSensors(process)
sensors = CreateSensors(process);
process.sensors_delayed = process.sensors_delayed(2:end);
process.sensors_delayed{end+1} = sensors;
end

function sensors = GetSensors(process)
sensors = process.sensors_delayed{1};
end

function [t,x] = Get_TandX_From_Process(process)
t = process.t;
x = [process.psi; process.psidot];
end

function u = GetInput(process,actuators)
% Copy input from actuators
u = [actuators.tau];

% Bound input
for i=1:length(u)
    if (u(i) < -process.tauMax)
        u(i) = -process.tauMax;
    elseif (u(i) > process.tauMax)
        u(i) = process.tauMax;
    end
end
end

function process = Get_Process_From_TandX(t,x,process)
process.t = t;
process.psi = x(1,1);
process.psidot = x(2,1);
% Update sensors
process = UpdateSensors(process);
end

function xdot = GetXDot(t,x,u,process)
% unpack x and u
psi = x(1,1);
psidot = x(2,1);
tau = u(1,1);
% compute xdot
xdot = process.f(psi, psidot, tau);
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
actuators = struct('tau',0);
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

    % Create axes for diagnostic plots
    if process.diagnostics
        fig.x.axis = axes('position',[0.55,0.7,0.4,0.225],'fontsize',fs);
        axis([0,process.tStop,-pi/2,pi/2]);
        hold on;
        fig.x.q = plot(nan,nan,'linewidth',2);
        fig.x.qd = plot(nan,nan,'linewidth',2);
        fig.x.legend = legend({'psi','psidot'});
        
        fig.y.axis = axes('position',[0.55,0.4,0.4,0.225],'fontsize',fs);
        axis([0,process.tStop,0,6]);
        hold on;
        grid on;
        fig.y.d = plot(nan,nan,'linewidth',2);
        fig.y.d_des = plot(nan,nan,'linewidth',2);
        fig.y.legend = legend({'d', 'd (desired)'});

        fig.u.axis = axes('position',[0.55,0.1,0.4,0.225],'fontsize',fs);
        delta = 0.1*process.tauMax;
        axis([0,process.tStop,-process.tauMax-delta,process.tauMax+delta]);
        hold on;
        fig.u.tau = plot(nan,nan,'linewidth',3);
        fig.u.umin = plot([0 process.tStop],-process.tauMax*[1 1],...
                          'linewidth',1,'linestyle','--','color','k');
        fig.u.umax = plot([0 process.tStop],process.tauMax*[1 1],...
                          'linewidth',1,'linestyle','--','color','k');
        fig.u.legend = legend({'tau'});
        xlabel('time');
    end

    % Create an axis for the view from frame 0.
    if process.diagnostics
        fig.view0.axis = axes('position',[0 0.02 0.5 1]);
        axis equal;
        axis([-4 4 -6 6]);
    else
        fig.view0.axis = axes('position',[0 0 1 1]);
        axis equal;
        axis([-5 5 -5 5]);
    end
    set(gcf,'renderer','opengl');
    set(gcf,'color','w');
    axis manual;
    hold on;
    axis off;
    box on;
    
    q = process.psi;
    r = process.r;
    x = process.x;
    y = process.y;
    
    fig.wheel = rectangle('position', [-r, -r, 2*r, 2*r], 'curvature', [1 1], 'facecolor', 'y', 'edgecolor', 'k');
    w = 0.05;
    fig.spring = line([r*cos(q), x], [r*sin(q), y], 'color', 'r', 'linewidth', 2);
    fig.center = rectangle('position', [-w, -w, 2*w, 2*w], 'curvature', [1 1], 'facecolor', 'w', 'edgecolor', 'k');
    fig.p = rectangle('position', [r * cos(q) - w, r * sin(q) - w, 2*w, 2*w], 'curvature', [1 1], 'facecolor', 'w', 'edgecolor', 'k');
    fig.q = rectangle('position', [x - w, y - w, 2*w, 2*w], 'curvature', [1 1], 'facecolor', 'w', 'edgecolor', 'k');
    s = 5 * w;
    fig.p_text = text((1+s)*r*cos(q), (1+s)*r*sin(q), 'p', 'fontsize', 14, 'horizontalalignment', 'center');
    fig.q_text = text(x+s*r, y+s*r, 'q', 'fontsize', 14, 'horizontalalignment', 'center');
    
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

if process.diagnostics
    t = get(fig.x.q,'xdata');
    x = get(fig.x.q,'ydata');
    set(fig.x.q,'xdata',[t process.t],'ydata',[x, process.psi]);
    
    t = get(fig.x.qd,'xdata');
    x = get(fig.x.qd,'ydata');
    set(fig.x.qd,'xdata',[t process.t],'ydata',[x, process.psidot]);
    
    t = get(fig.y.d,'xdata');
    x = get(fig.y.d,'ydata');
    set(fig.y.d,'xdata',[t process.t],'ydata',[x, controller.sensors.d]);
    
    t = get(fig.y.d_des,'xdata');
    x = get(fig.y.d_des,'ydata');
    set(fig.y.d_des,'xdata',[t process.t],'ydata',[x, controller.references.d]);
    
    t = get(fig.u.tau,'xdata');
    x = get(fig.u.tau,'ydata');
    set(fig.u.tau,'xdata',[t process.t],'ydata',[x controller.actuators.tau]);
end

q = process.psi;
r = process.r;
x = process.x;
y = process.y;

w = 0.05;
set(fig.p, 'position', [r * cos(q) - w, r * sin(q) - w, 2*w, 2*w]);
set(fig.spring, 'xdata', [r*cos(q), x], 'ydata', [r*sin(q), y]);
s = 5 * w;
set(fig.p_text, 'position', [(1+s)*r*cos(q), (1+s)*r*sin(q), 0]);

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

function onkeypress(src,event)
global done
if event.Character == 'q'
    done = true;
end
end

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
