%% Linearize about equilibrium point to get state space model

% parameters
params.m = 1;
params.g = 9.81;

% symbolic variables
syms z zdot thrust real

% equations of motion in the form mdot = f(m, n)
f = [zdot; thrust - params.m * params.g];

% equilibrium point
z_e = 0;
zdot_e = 0;
thrust_e = params.m * params.g;

% state space model (where x = m - m_e, u = n - n_e)
% - take partial derivatives
A = jacobian(f, [z, zdot]);
B = jacobian(f, [thrust]);
% - plug in equilibrium values
A = subs(A, [z, zdot, thrust], [z_e, zdot_e, thrust_e]);
B = subs(B, [z, zdot, thrust], [z_e, zdot_e, thrust_e]);
% - convert from symbolic to numeric
A = double(A);
B = double(B);

%% Do control design - pick K, check closed-loop stability

% Controller (save so we can load it for implementation)
K = [4 -4];
save('gainmatrix.mat', 'K');

% Closed-loop system, in the form xdot_m = A_m x_m
A_m = A - B * K;

% Eigenvalues of A_m, the "closed-loop A matrix"
s = eig(A_m)

%% Verify control design - x(t) from nonlinear simulation

% Define initial conditions
z_0 = 2;         % initial position
zdot_0 = 1;      % initial velocity

% Run simulation
DesignProblem00('Controller_StateFeedback', ...     % use this controller
                'display', false, ...               % do not show animation
                'tStop', 10, ...                    % stop simulation after 10 seconds
                'initial', [z_0; zdot_0], ...       % use this initial position and velocity
                'datafile', 'data.mat');            % save data to this file

% Load data
load('data.mat');

% Parse data
t = processdata.t;
z = processdata.z;
zdot = processdata.zdot;

% Find x(t)
x = [z - z_e; zdot - zdot_e];

% Plot data
figure(2);                                      % open new figure window
clf;                                            % clear figure window (if necessary)
plot(t, x(1, :), 'k-', 'linewidth', 2);         % plot, with a thick solid black line
hold on;                                        % can add more plots without erasing this one
plot(t, x(2, :), 'r-', 'linewidth', 1);         % plot, with a thin solid red line
axis([0, max(t), -3, 3]);                       % axis limits
set(gca, 'fontsize', 18);                       % big font size
xlabel('t');                                    % label t
ylabel('x(t)');                                 % label x(t)
legend({'x_1 (nonlinear)', 'x_2 (nonlinear)'}); % legend
grid on;                                        % turn on grid


%% Verify control design - x(t) from linear simulation

% Simulate
x0 = [z_0; zdot_0];                     % initial condition
x = zeros(2, length(t));                % place to put x(t)
for i = 1:length(t)                     % loop through each time
    x(:, i) = expm(A_m * t(i)) * x0;     % compute x(t) at each time
end

% Plot
figure(2);                                      % switch to this figure window
plot(t, x(1, :), 'k--', 'linewidth', 4);       % plot, with black dots
plot(t, x(2, :), 'r--', 'linewidth', 2);       % plot, with red circles
legend({'x_1 (nonlinear)', ...
        'x_2 (nonlinear)', ...
        'x_1 (linear)', ...
        'x_2 (linear)'});                       % legend


%% Save plot as PDF
figure(2);
set(gcf,'paperorientation', 'landscape');
set(gcf,'paperunits', 'normalized');
set(gcf,'paperposition', [0 0 1 1]);
print(gcf, '-dpdf', 'results.pdf');


%% Do control design - pick K and kRef, check closed-loop stability

% Output
C = [1 0];

% Controller (save so we can load it for implementation)
K = [4 4];
kRef = - 1 / (C * inv(A - B * K) * B);
save('gainmatrix.mat', 'K', 'kRef');

% Closed-loop system, in the form:
%
%   xdot_m = A_m x_m + B_m u_m
%      y_m = C_m x_m
%
A_m = A - B * K;
B_m = B * kRef;
C_m = C;

% Eigenvalues of A_m, the "closed-loop A matrix"
s = eig(A_m)

%% Verify control design - x(t) from nonlinear simulation

% Define initial conditions
z_0 = 0;         % initial position
zdot_0 = 0;      % initial velocity

% Run simulation
DesignProblem00('Controller_ReferenceTracking', ...     % use this controller
                'display', true, ...                   % do not show animation
                'tStop', 10, ...                        % stop simulation after 10 seconds
                'initial', [z_0; zdot_0], ...           % use this initial position and velocity
                'datafile', 'data.mat', ...             % save data to this file
                'reference', @(t) heaviside(t - 5));    % desired position as a function of time

% Load data
load('data.mat');

% Parse data
t = processdata.t;
z = processdata.z;
zdot = processdata.zdot;

% Find x(t)
x = [z - z_e; zdot - zdot_e];

% Find y(t)
y = C_m * x;

% Plot data
figure(2);                                      % open new figure window
clf;                                            % clear figure window (if necessary)
plot(t, y(1, :), 'k-', 'linewidth', 2);         % plot, with a thick solid black line
hold on;                                        % can add more plots without erasing this one
axis([0, max(t), -3, 3]);                       % axis limits
set(gca, 'fontsize', 18);                       % big font size
xlabel('t');                                    % label t
ylabel('y(t)');                                 % label y(t)
legend({'y (nonlinear)'});                      % legend
grid on;                                        % turn on grid


%% Verify control design - x(t) from linear simulation

% Simulate
x0 = [z_0; zdot_0];                     % initial condition
x = zeros(2, length(t));                % place to put x(t)
u_m = 1;                                 % reference
for i = 1:length(t)                     % loop through each time, computing x(t)
    x(:, i) = expm(A_m * t(i)) * x0 + inv(A_m) * (expm(A_m * t(i)) - eye(size(A_m))) * B_m * u_m;
end
y = C * x;

% Plot
figure(2);                                      % switch to this figure window
plot(t, y, 'k--', 'linewidth', 4);              % plot, very thick dotted line
legend({'y (nonlinear)', ...
        'y (linear)'});                       % legend


%% Save plot as PDF
figure(2);
set(gcf,'paperorientation', 'landscape');
set(gcf,'paperunits', 'normalized');
set(gcf,'paperposition', [0 0 1 1]);
print(gcf, '-dpdf', 'results.pdf');