%% Design Problem 4
clc;
clear all;
close all;
num_runs = 499;     % Change for how many roads to run per controller

%% Check if data for run exists
run = false;
file = [pwd '\results\' mat2str(num_runs) '_runs.mat'];
if isfile(file)
    in = input('Data already exists for number or runs, re-run the controllers? (y/n)   ', 's');
    clc;
    if strcmp(in, 'y')
        run = true;
    else
        run = false;
    end
else
    run = true;
end

%% Run Design Problem 4
if run
%     dist = zeros(3, num_runs);
%     time = zeros(3, num_runs);
%     avg_vel = zeros(3, num_runs);
%     finish_flag = zeros(3, num_runs);
%     road = zeros(3, num_runs);
%     iteration_time = zeros(3,1);

    for j = 1:3
        % Definitions
        controllername = sprintf('Controller%0.15g', j);
        datafile = 'data.mat';  
        roadfile = 'road_test.mat';
        display = false;              
        data_log = {'xhat', 'tStep'};
        tmp = [];
        parfor i = 499:num_runs
            datafile = sprintf('data_%0.15g.mat', i);
            roadfile = sprintf('roads\\road_%0.15g.mat', i);
            DesignProblem04(controllername, 'roadfile', roadfile, 'datafile', datafile, 'display', display, 'controllerdatatolog', data_log);

            tmp = load(datafile);
            dist(j,i) = calcDistance(tmp.processdata.v);
            time(j,i) = tmp.processdata.t(end);
            avg_vel(j,i) = mean(tmp.processdata.v)
            finish_flag(j,i) = tmp.processdata.result(end);
            road(j,i) = i;
            delete(datafile);
        end

    end
    % Save the data to a struct so iteration doesn't need to be re-run
    save(sprintf('results\\%0.15g_runs.mat', num_runs), 'time', 'dist', 'avg_vel', 'finish_flag', 'road')
end

%% Data Analysis
close all;
clc;
num_runs = 500;
f = load(sprintf('results\\%0.15g_runs.mat', num_runs));
output = [];
for j =1:3
    % Calc number of runs that pass validation
    dist = f.dist(j,1:end);
    avg_vel = f.avg_vel(j,1:end);
    time = f.time(j,1:end);
    finish_flag = f.finish_flag(j,1:end);
    road = f.road(j,1:end);
    
    road_length = 120;
    val_length_percentage = 1;
    dist_pass = road_length * val_length_percentage;
    num_road_pass = 0;
    pass_avg_vel = [];
    pass_avg_time = [];
    pass_time = [];
    pass_dist = [];
    for i = 1:length(dist)
        % Check if the robot finished the course
        if finish_flag(i) 
            num_road_pass = num_road_pass + 1;
            pass_avg_vel = [pass_avg_vel avg_vel(i)];
            pass_time = [pass_time time(i)];
            pass_dist = [pass_dist dist(i)];
        end
    end
    pass_average_velocity = mean(pass_avg_vel);
    pass_average_time = mean(pass_time);
    pass_average_distance = mean(pass_dist);
    average_velocity = mean(avg_vel);
    average_time = mean(time);
    average_distance = mean(dist);

    % Determine if controller is validated
    percentage_pass = 0.85;     % Success rate of goal
    validated = false;
    if (percentage_pass*num_runs) <= num_road_pass
        validated = true;
    end

    output = [output; [validated num_road_pass dist_pass round(percentage_pass*num_runs,0) round(pass_average_velocity, 2) round(pass_average_time, 2)]];

    % Plot histogram of runs (distance, velocity)
    hist_list = [avg_vel; dist];
    label_list = {'Average Velocity [m/s]', 'Average Distance [m]'};
    figure(j+3)
    set(gcf,'Position',[100 100 1500 400])
    for k = 1:2
        hist_run = hist_list(k,1:end);
        subplot(1, 2, k)
        histogram(hist_run, 75)
        set(gca,'fontsize',14);
        xlabel(label_list(k));
        ylabel('Frequency');
    end
    saveas(gcf, sprintf('plots\\histogram_controller%01.5g_%0.15gruns.png', j, num_runs));
    
    % Plot failure xhat
    xhat = [];
    statees = [];
    for r = 1:num_runs
        % Find roads that failed not at beggining and didn't finish, rerun
        % road and plot xhat
        if 5 <= dist(r) && ~finish_flag(r)
            % Definitions
            controllername = sprintf('Controller%0.15g', j);
            datafile = 'data.mat';  
            roadfile = sprintf('roads\\road_%0.15g.mat', r);
            display = false;              
            data_log = {'xhat'};
            %snapshotfile = sprintf('pics\\Controller%0.15gFail.pdf', j);
            %disp(sprintf('Road %0.15g meets failure criteria... running road', r))
            DesignProblem04(controllername, 'roadfile', roadfile, 'datafile', datafile, 'display', display, 'controllerdatatolog', data_log);
            %disp('Finished running controller')
            b = load(datafile);
            xhat        = b.controllerdata.data.xhat;
            eheading    = b.processdata.e_heading;
            elateral    = b.processdata.e_lateral;
            phi         = b.processdata.phi;
            phidot      = b.processdata.phidot;
            v           = b.processdata.v;
            w           = b.processdata.w;
            t           = b.processdata.t;
            states = [eheading; elateral; phi; phidot; v; w];
            delete(datafile);
            %disp('Finished saving data')
            break
        end
    end
    figure(j+6)
    set(gcf,'Position',[100 100 1000 400])
    color_list = {'b', 'y', 'r', 'g', 'k', 'c'};
    hold on
    ylim([-3 3])
    for l = 1:6
        plot(t, xhat(l,1:end), 'linewidth', 1)
    end
    hold off
    legend({'lateral error [m]', 'heading error [rad]', 'phi [rad]', 'phidot [rad/s]', 'velocity [m/s]', 'ang. velocity [radd/s]'}, 'fontsize', 14, 'location', 'eastoutside')
    ylabel('Unit', 'fontsize', 16);
    xlabel('Time (seconds)', 'fontsize', 16);
    saveas(gcf, sprintf('plots\\xhatFail_controller%01.5g_%0.15gruns.png', j, num_runs));
    
    
end

% Write summary
clc;
for i = 1:3
    out = output(i,1:end);
    if out(1)
        disp(sprintf('Controller %0.15g is validated!', i));
    else
        disp(sprintf('Controller %0.15g is NOT validated', i));
    end
    disp(sprintf('%0.15g roads travelled the required %0.15g meters, needed %0.15g roads', out(2), out(3), out(4)));
    disp(sprintf('Average speed = %0.15g m/s', out(5))); 
    disp(sprintf('Average time = %0.15g seconds', out(6))); 
    disp(sprintf('\n'));
end

%% Calculate distance function
function distance = calcDistance(v)
    % Calculate the distance by midpoint integration of velocity over time
    distance = 0;
    for j = 1:length(v(1:end-1))
        vi = v(j);
        vf = v(j+1);
        distance = distance + (vf+vi)/2 * 0.02;
    end
    if distance > 120
        distance = 120;
    end
end


