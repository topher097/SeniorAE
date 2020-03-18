function Day16
close all;
clc;

% Open-loop system
a = 5;
b = 1;

% Weights on cost
q = 1;
r = 1;

% Gain
k_step = linspace(5, 20, 1000);
total_cost_step = [];
for i = 1:length(k_step)
    k = k_step(i);
    % Initial condition
    t0 = 0;
    x0 = 1;

    % Total cost over the time interval [t0, t1]
    t1 = 5;
    total_cost = integral(@(t) integrand(t, a, b, k, q, r, t0, x0), t0, t1);
    total_cost_step = [total_cost_step, total_cost];
end

% Plot cost wrt t (fixed k)
figure();
t = linspace(0, t1, 1000);
k = 8;
for i = 1:length(t)
    cost_t(i) = integral(@(t) integrand(t, a, b, k, q, r, t0, x0), t0, t(i));
end
plot(t, cost_t)
xlabel('time')
ylabel('total cost')

% Plot cost wrt k (fixed t1)
figure();
plot(k_step, total_cost_step)
xlabel('k')
ylabel('total cost')

end


function cost_at_t = integrand(t, a, b, k, q, r, t0, x0)
% t is a matrix of times at which to compute the cost
% a, b, k, q, r, t0, x0 are parameters

% create a matrix in which to store the cost at each time
cost_at_t = zeros(size(t));

% iterate over times
for i = 1:length(t)
    % compute state at current time
    x = expm((a - b * k) * (t(i) - t0)) * x0;
    % compute input at current time
    u = -k * x;
    % compute cost at current time
    cost_at_t(i) = q * x^2 + r * u^2;
    
end

end
