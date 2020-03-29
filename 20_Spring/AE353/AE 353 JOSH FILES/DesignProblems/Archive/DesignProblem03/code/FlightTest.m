clear all, close all, clc
%% Initialize System
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
    clc
    Flight = Flight+1;
    X = [num2str(Flight), ' out of ', num2str(flights), ' flights'];
    disp(X)
    xFlights(i) = x(end);
end
disp('Simulator Complete!')
%%  Histogram and Statistics
figure(2)
histogram(xFlights)
    set(gca,'fontsize',14);
    xlabel('Distance (x)');
    ylabel('Frequency');
    set(gcf,'paperorientation','landscape');
    set(gcf,'paperunits','normalized');
    set(gcf,'paperposition',[0 0 1 1]);
    title(['Histogram of ', num2str(flights), ' simulated flights'])
    print(gcf,'-dpdf','flightsim.pdf');
Mean = mean(xFlights)
Median = median(xFlights)

%% Verification Test
if Mean >= 18;
    disp('Simulator verified')
else
    disp('Error, simulator not verified')
end