%% AE353 DP3 SP20
clc;
clear all;
close all;

%% Run simulation
%choice = input('Visual system? (1/0): ');
%flights = input('Flights Count: ');
choice = 0;
flights = 1000;
xFlights = zeros(1, flights);
max_state_error = [];
min_state_error = [];
max_time = [];
min_time = [];

Flight = 0;
launch = 15;
dat = {'xhat', 'x_e'};
min_dist = 5; max_dist = 5;
for i=1:flights
    if choice == 1
        DesignProblem03('Controller', 'datafile', 'data.mat', 'launchangle', deg2rad(launch), 'controllerdatatolog', dat, 'display', true, 'seed', i)
    elseif choice == 0
        DesignProblem03('Controller', 'datafile', 'data.mat', 'launchangle', deg2rad(launch), 'controllerdatatolog', dat, 'display', false, 'seed', i)
    end
    
    load('data.mat');
    x = processdata.x;
    distance = x(end);

    % Grab worst and best performance of state error
    if distance < min_dist
        min_xhat = controllerdata.data.xhat;
        min_time = processdata.t;
        min_x_e = controllerdata.data.x_e;
        min_state_error = min_xhat - min_x_e;
        min_dist = distance;
    end
    if distance > max_dist
        max_xhat = controllerdata.data.xhat;
        max_time = processdata.t;
        max_x_e = controllerdata.data.x_e;
        max_state_error = max_xhat - max_x_e;
        max_dist = distance;
    end
    
    clc
    Flight = Flight+1;
    X = [num2str(Flight), ' out of ', num2str(flights), ' flights'];
    disp(X)
    xFlights(i) = distance;
end
disp('Simulator Complete!')
%%  Histogram and Statistics
%clc;
close all;
% Histogram
Mean = mean(xFlights)
Median = median(xFlights)
Std = std(xFlights)
figure(2)
set(gcf,'Position',[100 100 900 400])
histogram(xFlights, 50)
[counts binValues] = hist(xFlights, 50);
[x,y] = find(counts==max(max(counts)));
hold on
h1 = plot(Mean*ones(1, flights), linspace(0, counts(1,y), flights), 'g--', 'Linewidth', 1.5);
h2 = plot(Median*ones(1, flights), linspace(0, counts(1,y), flights), 'r--', 'Linewidth', 1.5);
h3 = plot(Mean - Std*ones(1, flights), linspace(0, counts(1,y), flights), 'y--', 'Linewidth', 1.5);
h4 = plot(Mean + Std*ones(1, flights), linspace(0, counts(1,y), flights), 'y--', 'Linewidth', 1.5);
hold off
set(gca,'fontsize',14);
xlabel('x - Distance [m]');
ylabel('Frequency');
legend([h1, h2, h3], {sprintf('Mean = %0.15g m', round(Mean,2)), sprintf('Median = %0.15g m', round(Median, 2)), sprintf('Std. Dev. = %0.15g m', round(Std, 2))}, 'location', 'northwest')
%title(['Histogram of ', num2str(flights), ' simulated flights'])
saveas(gcf, sprintf('plots\\histogram_%0.15g_flights.png', flights));

% Minimum Error
figure(3)
set(gcf,'Position',[100 500 900 400])
hold on
yline(0, 'k--');
lw = 1.5;
plot(min_time, min_state_error(1,:), 'b', 'linewidth', lw) % theta
plot(min_time, min_state_error(2,:), 'r', 'linewidth', lw) % phi
plot(min_time, min_state_error(3,:), 'g', 'linewidth', lw) % xdot
plot(min_time, min_state_error(4,:), 'y', 'linewidth', lw) % ydot
plot(min_time, min_state_error(5,:), 'color', [.5 .4 .7], 'linewidth', lw) % thetadot
grid on
hold off
xlabel('Time (seconds)', 'FontSize', 14)
ylabel('Unit (rad, rad/s, m/s)', 'FontSize', 14)
%title(sprintf('State Error for Minumum Distance of %0.15g m', round(min_dist,2)), 'fontsize', 16)
theta_text = '$\Theta$ Error';
phi_text = '$\Phi$ Error';
xdot_text = '$\dot{x}$ Error';
ydot_text = '$\dot{y}$ Error';
thetadot_text = '$\dot{\Theta}$ Error';
name = legend({theta_text, phi_text, xdot_text, ydot_text, thetadot_text}, 'Location', 'northeastoutside', 'Fontsize', 12);
set(name,'Interpreter','latex');
saveas(gcf, sprintf('plots\\min_%0.15g_flights.png', flights));

% Maximum Error
figure(4)
set(gcf,'Position',[800 500 900 400])
hold on
yline(0, 'k--');
lw = 1.5;
plot(max_time, max_state_error(1,:), 'b', 'linewidth', lw) % theta
plot(max_time, max_state_error(2,:), 'r', 'linewidth', lw) % phi
plot(max_time, max_state_error(3,:), 'g', 'linewidth', lw) % xdot
plot(max_time, max_state_error(4,:), 'y', 'linewidth', lw) % ydot
plot(max_time, max_state_error(5,:), 'color', [.5 .4 .7], 'linewidth', lw) % thetadot
grid on
hold off
xlabel('Time (seconds)', 'FontSize', 14)
ylabel('Unit (rad, rad/s, m/s)', 'FontSize', 14)
%title(sprintf('State Error for Maximum Distance of %0.15g m', round(max_dist,2)), 'fontsize', 16)
theta_text = '$\Theta$ Error';
phi_text = '$\Phi$ Error';
xdot_text = '$\dot{x}$ Error';
ydot_text = '$\dot{y}$ Error';
thetadot_text = '$\dot{\Theta}$ Error';
name = legend({theta_text, phi_text, xdot_text, ydot_text, thetadot_text}, 'Location', 'northeastoutside', 'Fontsize', 12);
set(name,'Interpreter','latex');
saveas(gcf, sprintf('plots\\max_%0.15g_flights.png', flights));

%% Verification Test
if Mean >= 15
    disp('Simulator verified')
else
    disp('Error, simulator not verified')
end
