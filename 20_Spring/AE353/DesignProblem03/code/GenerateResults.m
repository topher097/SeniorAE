%% AE353 DP3 SP20
clc;
clear all;
close all;
%% Run simulation
choice = input('Visual system? (1/0): ');
flights = input('Flights Count: ');
xFlights = zeros(1, flights);
xValue = [];
tValue = [];
Flight = 0;
for i=1:flights
    if choice == 1
        DesignProblem03('Controller', 'datafile', 'data.mat', 'launchangle', deg2rad(4), 'display', true)
    elseif choice == 0
        DesignProblem03('Controller', 'datafile', 'data.mat', 'launchangle', deg2rad(4), 'display', false)
    end
    load('data.mat');
    
    x = processdata.x;
    t = processdata.t;
    xValue = [xValue x];
    tValue = [tValue t];
    %clc
    Flight = Flight+1;
    X = [num2str(Flight), ' out of ', num2str(flights), ' flights'];
    disp(X)
    xFlights(i) = x(end);
end
disp('Simulator Complete!')
%%  Histogram and Statistics
%clc;
Mean = mean(xFlights)
Median = median(xFlights)
figure(2)
set(gcf,'Position',[100 100 900 400])
histogram(xFlights, 50)
[counts binValues] = hist(xFlights, 50);
[x,y] = find(counts==max(max(counts)));
hold on
h1 = plot(Mean*ones(1, flights), linspace(0, counts(1,y), flights), 'g--', 'Linewidth', 1.5);
h2 = plot(Median*ones(1, flights), linspace(0, counts(1,y), flights), 'r--', 'Linewidth', 1.5);
hold off
set(gca,'fontsize',14);
xlabel('x - Distance [m]');
ylabel('Frequency');
legend([h1, h2], {sprintf('Mean = %0.15g m', round(Mean,2)), sprintf('Median = %0.15g m', round(Median, 2))}, 'location', 'northwest')
title(['Histogram of ', num2str(flights), ' simulated flights'])
saveas(gcf, sprintf('plots\\histogram_%0.15g_flights.png', flights));


%% Verification Test
if Mean >= 18
    disp('Simulator verified')
else
    disp('Error, simulator not verified')
end