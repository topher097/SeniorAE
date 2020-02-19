function DesignProblem01(controller,varargin)
% DesignProblem01   run simulation of 2D quadrotor
%
%   DesignProblem01('FunctionName') uses the controller defined by
%       the function 'FunctionName' - for example, in a file with
%       the name FunctionName.m - in the simulation.
%
%   DesignProblem01('FunctionName','P1',V1,'P2','V2',...) optionally
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
%           'diagnostics' : a flag - true or false (default) that, if true,
%                           will show plots of state and actuator values
%
%           'tStop' : the time at which the simulation will stop (a
%                     positive number) - default value is 30
%
%           'disturbance' : a flag - true or false (default) that, if true,
%                           will add an unknown payload
%
%           'reference' : a function of time that specifies a reference
%                         value of py - for example, the following choice
%                         would specify a reference value py(t) = sin(t):
%                           @(t) sin(t)
%
%           'initial' : a 6x1 matrix
%                           [q1, q2, q3, q1dot, q2dot, q3dot]
%                       that specifies initial values - by default, these
%                       values are:
%                           a + b.*randn(6,1)
%                       where
%                           a = [0; 0; 0; 0; 0; 0]
%                           b = [1; 1; pi/6; 0.1; 0.1; 0.1]
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
addParameter(p,'diagnostics',false,@islogical);
addParameter(p,'tStop',30,@(x) isscalar(x) && isnumeric(x) && (x>0));
addParameter(p,'disturbance',false,@islogical);
addParameter(p,'reference',@(x)0,@(x) isa(x,'function_handle'));
addParameter(p,'initial',[0; 0; 0; 0; 0; 0]+[1; 1; pi/6; 0.1; 0.1; 0.1].*randn(6,1),...
                         @(x) validateattributes(x,{'numeric'},{'size',[6 1]}));
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
process.processdatatolog = {'t', 'q1', 'q2', 'q3', 'q1dot', 'q2dot', 'q3dot'};

% Constants related to physical properties.
% - Acceleration of gravity
process.g = 9.81;
% - Mass
process.m = 1.50;
if process.disturbance
    process.m_actual = process.m * (1 + 0.5 * rand);
else
    process.m_actual = process.m;
end
% - Moment of inertia
process.J = 0.25;
% - Spar length
process.r = 0.75;
% - Maximum thrust of each rotor
process.fmax = 10;

% DEFINE VARIABLES

% Time
process.t = 0;
% Position and orientation
process.q1 = process.initial(1, 1);
process.q2 = process.initial(2, 1);
process.q3 = process.initial(3, 1);
% Linear and angular velocity
process.q1dot = process.initial(4, 1);
process.q2dot = process.initial(5, 1);
process.q3dot = process.initial(6, 1);

% DEFINE CONTROLLER

% Functions
% - get handles to user-defined functions 'init' and 'run'
controller = eval(process.controller);
controller.name = process.controller;
% Parameters
% - define a list of constants that will be passed to the controller
names = {'tStep', 'g', 'm', 'J', 'r', 'fmax'};
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
    references = struct('q2', process.reference(process.t));
catch exception
    warning(['The ''references'' function that was passed to\n' ...
             'DesignProblem01 threw the following error:\n\n' ...
             'threw the following error:\n\n' ...
             '==========================\n' ...
             '%s\n', ...
             '==========================\n\n' ...
             'Leaving references unchanged.\n'],getReport(exception));
    references = struct('q2', 0);
end
end

function sensors = GetSensors(process)
sensors.t = process.t;
sensors.q1 = process.q1;
sensors.q2 = process.q2;
sensors.q3 = process.q3;
sensors.q1dot = process.q1dot;
sensors.q2dot = process.q2dot;
sensors.q3dot = process.q3dot;
% Add noise
%   (nothing)
end

function [t,x] = Get_TandX_From_Process(process)
t = process.t;
x = [process.q1; process.q2; process.q3; process.q1dot; process.q2dot; process.q3dot];
end

function u = GetInput(process,actuators)
% Copy input from actuators
u = [actuators.fR; actuators.fL];

% Bound input
for i=1:length(u)
    if (u(i) < 0)
        u(i) = 0;
    elseif (u(i) > process.fmax)
        u(i) = process.fmax;
    end
end

% Add disturbance
%   (nothing)
end

function process = Get_Process_From_TandX(t,x,process)
process.t = t;
process.q1 = x(1,1);
process.q2 = x(2,1);
process.q3 = x(3,1);
process.q1dot = x(4,1);
process.q2dot = x(5,1);
process.q3dot = x(6,1);
end

function xdot = GetXDot(t,x,u,process)
% unpack x and u
q1 = x(1,1);
q2 = x(2,1);
q3 = x(3,1);
q1dot = x(4,1);
q2dot = x(5,1);
q3dot = x(6,1);
fR = u(1,1);
fL = u(2,1);
% compute xdot
xdot = [q1dot;
        q2dot;
        q3dot;
        - (fR + fL) * sin(q3) / process.m_actual;
        ((fR + fL) * cos(q3) - process.m_actual * process.g) / process.m_actual;
        process.r * (fR - fL) / process.J];
end

function iscorrect = CheckActuators(actuators)
iscorrect = false;
if all(isfield(actuators,{'fR', 'fL'}))&&(length(fieldnames(actuators))==2)
    if isnumeric(actuators.fR)&&isnumeric(actuators.fL)
        if isscalar(actuators.fR)&&isscalar(actuators.fL)
            if (~isnan(actuators.fR))&&(~isinf(actuators.fR))&&(~isnan(actuators.fL))&&(~isinf(actuators.fL))
                iscorrect = true;
            end
        end
    end
end
end

function actuators = ZeroActuators()
actuators = struct('fR', 0, 'fL', 0);
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
        fig.x.axis = axes('position',[0.55,0.6,0.4,0.35],'fontsize',fs);
        axis([0,process.tStop,-3,3]);
        hold on;
        fig.x.q1 = plot(nan,nan,'linewidth',2);
        fig.x.q2 = plot(nan,nan,'linewidth',2);
        fig.x.q3 = plot(nan,nan,'linewidth',2);
        fig.x.ref = plot(nan,nan,':','linewidth',3);
        fig.x.legend = legend({'q1','q2','q3', 'q2 (desired)'});
        xlabel('time');

        fig.u.axis = axes('position',[0.55,0.1,0.4,0.35],'fontsize',fs);
        delta = 0.1*process.fmax;
        axis([0,process.tStop,0-delta,process.fmax+delta]);
        hold on;
        fig.u.fR = plot(nan,nan,'linewidth',3,'color',[0.4940 0.1840 0.5560]);
        fig.u.fL = plot(nan,nan,'linewidth',3,'color',[0.4660 0.6740 0.1880]);
        fig.u.umin = plot([0 process.tStop],[0 0],...
                          'linewidth',1,'linestyle','--','color','k');
        fig.u.umax = plot([0 process.tStop],process.fmax*[1 1],...
                          'linewidth',1,'linestyle','--','color','k');
        fig.u.legend = legend({'fR', 'fL'});
        xlabel('time');
    end
    
    % Create an axis for the view from frame 0.
    if process.diagnostics
        fig.view0.axis = axes('position',[0 0.02 0.5 1]);
        axis equal;
        axis([-4 4 -4 4 -6 6]);
    else
        fig.view0.axis = axes('position',[0 0 1 1]);
        axis equal;
        axis([-5 5 -5 5 -3 3]);
    end
    set(gcf,'renderer','opengl');
    set(gcf,'color','w');
    axis manual;
    hold on;
    axis off;
    view([0,90]);
    box on;
    set(gca,'projection','perspective');
    set(gca,'clipping','on','clippingstyle','3dbox');
    lighting gouraud
    fig.view0.light = light('position',[0;-2;2],'style','local');
    
    pFrame = [0 1 0 0;
              0 0 1 0;
              0 0 0 1];
    fig.geom.pFrame0_in0 = pFrame;
    fig.geom.pFrame1_in1 = pFrame;
    
    [fig.geom.pRobot_in1,fig.geom.fRobot]=GetRobotModel('quadmodel.mat');
    
    R_Min1 = [1 0 0;
              0 0 -1;
              0 1 0];
    o_1in0 = [process.q1; process.q2; 0];
    R_1in0 = [cos(process.q3) -sin(process.q3) 0; sin(process.q3) cos(process.q3) 0; 0 0 1];
    fig.geom.pFrame1_in0 = Transform(o_1in0, R_1in0, fig.geom.pFrame1_in1);
    fig.geom.pRobot_in0 = Transform(o_1in0, R_1in0 * R_Min1, fig.geom.pRobot_in1);
    
    fig.view0.frame0 = DrawFrame([], fig.geom.pFrame0_in0);
    fig.view0.frame1 = DrawFrame([], fig.geom.pFrame1_in0);
    fig.view0.robot = DrawMesh([], fig.geom.pRobot_in0, fig.geom.fRobot, 'y', 0.9);
    
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
    
    % FIXME
    
    t = get(fig.x.q1,'xdata');
    x = get(fig.x.q1,'ydata');
    set(fig.x.q1,'xdata',[t process.t],'ydata',[x process.q1]);

    t = get(fig.x.q2,'xdata');
    x = get(fig.x.q2,'ydata');
    set(fig.x.q2,'xdata',[t process.t],'ydata',[x process.q2]);
    
    t = get(fig.x.q3,'xdata');
    x = get(fig.x.q3,'ydata');
    set(fig.x.q3,'xdata',[t process.t],'ydata',[x process.q3]);

    t = get(fig.x.ref,'xdata');
    x = get(fig.x.ref,'ydata');
    set(fig.x.ref,'xdata',[t process.t],'ydata',[x controller.references.q2]);

    t = get(fig.u.fR,'xdata');
    x = get(fig.u.fR,'ydata');
    set(fig.u.fR,'xdata',[t process.t],'ydata',[x controller.actuators.fR]);
    
    t = get(fig.u.fL,'xdata');
    x = get(fig.u.fL,'ydata');
    set(fig.u.fL,'xdata',[t process.t],'ydata',[x controller.actuators.fL]);
end

R_Min1 = [1 0 0;
          0 0 -1;
          0 1 0];
o_1in0 = [process.q1; process.q2; 0];
R_1in0 = [cos(process.q3) -sin(process.q3) 0; sin(process.q3) cos(process.q3) 0; 0 0 1];
fig.geom.pFrame1_in0 = Transform(o_1in0, R_1in0, fig.geom.pFrame1_in1);
fig.geom.pRobot_in0 = Transform(o_1in0, R_1in0 * R_Min1, fig.geom.pRobot_in1);

fig.view0.frame1 = DrawFrame(fig.view0.frame1, fig.geom.pFrame1_in0);
fig.view0.robot = DrawMesh(fig.view0.robot, fig.geom.pRobot_in0);
    
drawnow;
end

function [p,f]=GetRobotModel(filename)
load(filename);
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

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


