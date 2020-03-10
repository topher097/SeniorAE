%% Simulation Loop
%Number of Flights
nFlights = 1000;
%Loop over each flight
x = [];
z = clock;
for i=1:nFlights
    DesignProblem03('Controller_dsinge3','datafile','data.mat','display',false);
    load('data.mat');
    t = processdata.t;
    x = [x,processdata.x(end)];
    disp(i)
end
elapsedTime = etime(clock, z)

%% Data Analysis Section
a = linspace(1,length(x),length(x));
info.elapsedTime = elapsedTime;
info.x = x;
info.a = a;
info.std = std(x);
info.median = median(x);
info.min = min(x);
info.max = max(x);
info.mean = mean(x);
histogram = histogram(info.x);
title('Histogram of Flights (n=1000)')
xlabel('Distance of Flight')
ylabel('Frequency of Flight Distance')
save('Simulation_Data.mat','info')
save('Histogram.fig','histogram');
info