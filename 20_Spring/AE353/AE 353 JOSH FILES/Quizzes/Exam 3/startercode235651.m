function startercode235651
[T,X,U,XFORDISPLAY] = RunSimulation;
PlotResults(T,X,U);
p = mat2str(XFORDISPLAY(1),4)
pdot = mat2str(XFORDISPLAY(2),4)
end

function [actuators,data] = initControlSystem(sensors,references,parameters,data)
%%%%%%%%%%%%%%%%%%
% MODIFY
data.A = [0 1; (-100/20)*cos(-0.8) -5/20];
data.B = [0 ; 1/20];
data.C = [0 1];
data.K = acker(data.A,data.B,[-1,-0.5]);
data.L = acker(data.A',data.C',[-5,-2.5])';
data.xhat = [0;0];
%
%%%%%%%%%%%%%%%%%%
[actuators,data] = runControlSystem(sensors,references,parameters,data);
end

function [actuators,data] = runControlSystem(sensors,references,parameters,data)
%%%%%%%%%%%%%%%%%%
% MODIFY
u = -data.K*data.xhat;
y = sensors.pdot;
data.xhat = data.xhat + (data.A*data.xhat + data.B*u - data.L*(data.C*data.xhat - y))*parameters.tStep;
actuators.f = u + 100*sin(-0.8);
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
    x = x (end,:)';
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
x = [-0.10; 0.30];
tStep = 0.007;
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
xdot = [x(2); (1/20)*(-(5*x(2)+100*sin(x(1)))+u(1))];
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