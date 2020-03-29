%% Propblem 1
function [t,u] = integrator(L, Nx, PeriodicFlag, T, Nt, u0, spacedef, casedef)
% Inputs:
% 
% L: length of the physical domain, x is from 0 to L
% Nx: number of points which to discretize x
% Periodicflag: if 1, then periodic
%               if 0, then non-periodic
% T: lenght of the time domain, t is from 0 to T
% Nt: number of points which to discretise t (note that ode45 uses dt, this is for reporting only)
% spacedef: string to select spacial derivative operator
% casedef: string to select governing equation
% 
% Output:
% t: time vector
% u: solution vector

% Create the spacial domain
if (PeriodicFlag == 0)
    dx = L/Nx;
else
    dx = L/(Nx-1);
end
x = dx*linspace(0, Nx-1, Nx).';

% Create the time domain
dt = T/(Nt-1);
t = dt*linspace(0,Nt-1,Nt);

% Define the spacial operator
if strcmpi('Central2First', spacedef)
    D1 = sparse(Central2(Nx, dx, PeriodicFlag));
elseif strcmpi('First', spacedef)
    D1 = sparse(First(Nx, dx));
elseif strcmpi('Second', spacedef)
    D1 = sparse(Second(Nx, dx));
elseif strcmpi('Third', spacedef)
    D1 = sparse(Third(Nx, dx));
else
    error(sprintf('Unknown spacdef string = %s',spacedef));
end

% Define the initial condition
syms x_s
u0 = double(subs(u0, x_s, x));

% Run the case
if strcmpi('LinearAdvection', casedef)
    [t,u] = ode45(@(t,y) LinearAdvection(t,y,D1), t, u0);
elseif strcmpi('ConservativeBurgers', casedef)
    [t,u] = ode45(@(t,y) ConservativeBurgers(t,y,D1), t, u0);
else
    error(sprintf('Uknown casedef string = %s',casedef));
end

return
end