function startercode181744
[T,X,U,XFORDISPLAY] = RunSimulation;
PlotResults(T,X,U);
z = mat2str(XFORDISPLAY(1),8)
zdot = mat2str(XFORDISPLAY(2),8)
end

function [actuators,data] = initControlSystem(sensors,references,parameters,data)
data.A = [0 1; -(4+4*3*5^2)/6 -1/6];
data.B = [0;1/6];
data.C = [0,1];
data.xhat = [0;0];
data.u=0;
Qc = eye(2);
Rc = .6;
Qo = 9.7;
Ro= eye(2);
data.K = lqr(data.A,data.B,Qc,Rc);
data.L = lqr(data.A',data.C',inv(Ro),inv(Qo))';
data.K
data.L
[actuators,data] = runControlSystem(sensors,references,parameters,data);
end

function [actuators,data] = runControlSystem(sensors,references,parameters,data)
u=-data.K*data.xhat;
y=sensors.zdot-5;
data.xhat=data.xhat+(data.A*data.xhat+data.B*u-data.L*(data.C*data.xhat-y))*parameters.tStep;
actuators.v= u+4*5+4*5^3;
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
x = [5.80; -0.40];
tStep = 0.006;
nStepsForDisplay = 25;
nSteps = 250;
end

function u = GetInput(actuators)
u = actuators.v;
end

function sensors = GetSensors(t,x)
sensors.t = t;
sensors.zdot = x(2);
end

function xdot = GetXDot(t,x,u)
xdot = [x(2); (1/6)*(-(1*x(2)+4*x(1)+4*x(1)^3)+u(1))];
end

function PlotResults(T,X,U)
clf;
subplot(2,1,1);
plot(T,X);
legend('z','zdot');
subplot(2,1,2);
plot(T(1:end-1),U);
legend('v');
end
