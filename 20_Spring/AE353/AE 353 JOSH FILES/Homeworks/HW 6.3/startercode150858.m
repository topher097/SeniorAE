function startercode150858
[T,X,U,XFORDISPLAY] = RunSimulation;
PlotResults(T,X,U);
p = mat2str(XFORDISPLAY(1),4)
pdot = mat2str(XFORDISPLAY(2),4)
end

function [actuators,data] = initControlSystem(sensors,references,parameters,data)
%%%%%%%%%%%%%%%%%%
% MODIFY
% 27*pDD+8*pD+90*cos(p)==f
data.A = [0, 1; -0.3328, -0.2963];
data.B = [0; 0.0370];
data.C = [1, 0];
data.xhat = [0; 0];
data.u = 0;

pcon = [-3, -1.5];
pobs = [-9, -4.5];

data.K = acker(data.A, data.B, pcon);
data.L = acker(data.A', data.C', pobs)';
data.K
data.L
%
%%%%%%%%%%%%%%%%%%
[actuators,data] = runControlSystem(sensors,references,parameters,data);
end

function [actuators,data] = runControlSystem(sensors,references,parameters,data)
%%%%%%%%%%%%%%%%%%
% MODIFY
pE = -.1;
fE = 90*cos(pE); % if y = pdot don't take deriv, if y = p = pE take deriv
u = -data.K*data.xhat;
y = sensors.pdot;
%y = sensors.p-pE;
data.xhat=data.xhat+(data.A*data.xhat+data.B*u-data.L*(data.C*data.xhat-y))*parameters.tStep;
actuators.f = u + fE;
%
%%%%%%%%%%%%%%%%%%
end

function [T,X,U,XFORDISPLAY] = RunSimulation
[t,x,tStep,nSteps,nStepsForDisplay] = InitSimulation;
T = t;
X = x;
U = [];
controller.init = @initControlSystem;
controller.run = @runControlSystem;
controller.sensors = GetSensors(t,x);
controller.references = struct;
controller.parameters = struct('tStep',tStep);
controller.data = struct;
[controller.actuators,controller.data] = ...
    controller.init(controller.sensors, ...
                    controller.references, ...
                    controller.parameters, ...
                    controller.data);
for iStep = 1:nSteps
    u = GetInput(controller.actuators);
    [t,x] = ode45(@(t,x) GetXDot(t,x,u),[t t+tStep],x);
    t = t(end);
    x = x(end,:)';
    controller.sensors = GetSensors(t,x);
    [controller.actuators,controller.data] = ...
    controller.run(controller.sensors, ...
                    controller.references, ...
                    controller.parameters, ...
                    controller.data);
    T = [T t];
    X = [X x];
    U = [U u];
    if iStep==nStepsForDisplay
        XFORDISPLAY = x;
    end
end
end

function [t,x,tStep,nSteps,nStepsForDisplay] = InitSimulation
t = 0;
x = [0.60; -0.30];
tStep = 0.004;
nStepsForDisplay = 25;
nSteps = 250;
end

function u = GetInput(actuators)
u = actuators.f;
end

function sensors = GetSensors(t,x)
sensors.t = t;
sensors.pdot = x(2);
end

function xdot = GetXDot(t,x,u)
xdot = [x(2); (1/27)*(-(8*x(2)+90*cos(x(1)))+u(1))];
end

function PlotResults(T,X,U)
clf;
subplot(2,1,1);
plot(T,X);
legend('p','pdot');
subplot(2,1,2);
plot(T(1:end-1),U);
legend('f');
end
