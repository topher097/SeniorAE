function [data] = ae483_04_experiment(h_num, K, x_e, u_e, sampleNumber, x0)

% Physical parameters that govern the motors and rotors.
%   (sigma = alpha * mu + beta)
kF = 4.5508e-6;
alpha = 3.8467;
beta = 100.5216;
l = 0.1725;
s_min = (alpha * 1 + beta)^2;      % minimum squared spin rate of each rotor
s_max = (alpha * 200 + beta)^2;    % maximum squared spin rate of each rotor


% Choose a sample rate. This is the number of times per second that the
% controller will run. This is also the number of times per second that
% data will be collected (at least, in the simulation I've created here -
% as you know, things are different in the hardware experiments, where the
% onboard controller and the offboard data logger run at different rates).
sampleRate = 50;

% Compute the time step. This is the length of time between one sample and
% the next.
tStep = 1 / sampleRate;

% Choose an integer number of time steps to run the simulation for (i.e.,
% samples to take). The total simulation time is then
%
%   num_samples / sample_rate
%
% sampleNumber = 100;

% Define the initial state (i.e., the state at time zero, at the very start
% of the simulation). To compare your results with an experiment, it would
% be very important to match the initial state here with the one you used
% in your experimenu_ct (so you should get it from your data).
% x0 = [-2; 0];the 

% Define variables to keep track of the time, state, and input during the
% simulation. I like to put these variables all together in a struct - that
% makes it easy to store and pass the data around, and also to add more
% things to the data later on if I want (rotor spin rates, for example).
%
% I initialize the time and state with their initial values. I initialize
% the input as an empty matrix - no inputs have been chosen yet.
data = struct('t', 0, 'x', x0, 'u', []);

% Loop through all time steps.
for i = 1:sampleNumber
    
    % The "current time" is at time step "i". So, the current time and
    % state are in the i'th column of data.t and data.x.
    t = data.t(:, i);
    x = data.x(:, i);
    
    % Choose input based on the current time and state.
    % - Compute state of linear system.
    x_c = x - x_e;
    % - Compute input of linear system (by state feedback).
    u_c = -K * x_c;
    % - Compute input of original, nonlinear system.
    u = u_c + u_e;
    
    % - Compute squared spin rates
    s1 = u / (kF * l);
    s2 = - u / (kf * l);
    s = [s1; s2];
    % - Bound squared spin rates
    for j = 1:length(s)
        if s(j) < s_min
            s(j) = s_min;
        elseif s(j) > s_max
            s(j) = s_max;
        end
    end
    % - Compute input of original, nonlinear system (again).
    u = (kF * ones(1, 2)) * s;
    
    % - Store current input in data structure.
    data.u(:, i) = u;
    
    % Numerically integrate equations of motion to compute what the next
    % state will be given the current state and input.
    %
    %   @(t, x) h_num(x, u)     This is a anonymous function that ode45
    %                           will call to find xdot as a function of t
    %                           and x. The syntax means that when ode45
    %                           calls this anonymous function with (t, x),
    %                           this function will return the value
    %                           h_num(x, u). Note that the "x" comes from
    %                           ode45 and is changing all the time, while
    %                           the "u" is what we computed above, from the
    %                           controller, and is constant over each time
    %                           step. For help on anonymous functions, do:
    %
    %                               doc anonymous
    %
    %   [t, t + tStep]          This is the time interval to simulate. The
    %                           state (i.e., current) time is t, the final
    %                           (i.e., next) time is t + tStep.
    %
    %   x                       This is the state at the state of the time
    %                           interval that we want to simulate. In other
    %                           words, it is the current state.
    %
    [t_sol, x_sol] = ode45(@(t, x) h_num(x, u), [t, t + tStep], x);
    
    % Parse the solution that is returned by ode45 and store the next time
    % and state in our data structure. These will become the *current* time
    % and state the next time through our loop.
    %
    % Here is what ode45 returns:
    %
    %   t_sol       m x 1 matrix of times
    %   x_sol       m x n matrix of states, where the state time t_sol(i)
    %               is given by the 1 x n matrix x_sol(i, :)
    %
    % So, the "next time" is the last element of t_sol, and the "next
    % state" is the last row of x_sol. I always prefer to represent the
    % state as an n x 1 matrix instead of as a 1 x n matrix, so I take the
    % transpose of the result before storing it in data.
    data.t(:, i + 1) = t_sol(end, :);
    data.x(:, i + 1) = x_sol(end, :)';
end

end