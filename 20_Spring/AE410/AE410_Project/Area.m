function [A,dA] = Area(x)
    % Input is the x location on the nozzle
    % OUTPUT: Area and the Change in Area
    A0 = 0.2;
    rc = 0.5;
    x0 = 0.5;
    tanTheta = 0.25;

    % Linear part of the nozzle
    S1 =  tanTheta*x;
    S2 = (tanTheta*x0)-tanTheta*(x-x0);

    % Solve the non-linear equation to patch the linear and the circular part
    % of the nozzle geometry. It is commented to save computational time.
    % The function to be solved for is root.m

    % options = optimoptions('fsolve','Display','none','PlotFcn',@optimplotfirstorderopt);
    % fun = @root;
    % xt = 0.3;
    % format long
    % xpatch = fsolve(fun,xt,options)
    xpatch = 0.378732187461209; 

    b = tanTheta*xpatch - sqrt(rc^2 - (xpatch-x0)^2);

    inlet = find(x<xpatch);
    delta = x0 - xpatch;
    outlet = find(x>x0+delta);
    A = sqrt(rc^2 - (x-x0).^2)+b;
    A(inlet) = S1(1:max(inlet));
    A(outlet)= S2(min(outlet):length(x));
    A = A0-A;

    dA         = (-x0 + x)./sqrt((1.0 - x).*x);
    dA(inlet)  = -tanTheta;
    dA(outlet) =  tanTheta;
end

