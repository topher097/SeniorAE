clear all, close all, clc
%{
Readme:
    In order for this program to work, you will need all three controllers
    in the same folder or path.  The submitted controller file is the
    Optimal_Controller, or selection == 3.  You can find all three
    controllers in the zip file if you wish to test the slow controller and
    error controller.
%}

%% Initialize:
% Pick a controller:
selection = input('Please pick a controller: (Accurate:1, Error Prone:2, Supra:3): ');
makenewroad = input('Do you want to generate a random road file? (Yes:1, no:0): ');

if makenewroad == 1
    if selection == 1
        MakeRoad
        DesignProblem04('Slow_Controller', 'datafile', 'dataslow.mat', 'display', true)
    elseif selection == 2
        MakeRoad
        DesignProblem04('Error_Controller', 'datafile', 'dataerror.mat', 'display', true)
    elseif selection == 3
        MakeRoad
        DesignProblem04('Optimal_Controller', 'datafile','dataoptimal.mat', 'display', true)
    end
elseif makenewroad == 0
    if selection == 1
        DesignProblem04('Slow_Controller', 'datafile', 'dataslow.mat', 'display', true)
    elseif selection == 2
        DesignProblem04('Error_Controller', 'datafile', 'dataerror.mat', 'display', true)
    elseif selection == 3
        DesignProblem04('Optimal_Controller', 'datafile','dataoptimal.mat', 'display', true)
    end
end

%% Verification Test:
speedTest = false;
if selection == 1
    load('dataslow.mat')
    for i=1 : length(processdata.v)
        if processdata.v(i) > 3
            speedTest = true;
        end
    end
elseif selection == 2
    load('dataerror.mat')
        for i=1 : length(processdata.v)
            if processdata.v(i) > 3
                speedTest = true;
            end
        end
elseif selection == 3
    load('dataoptimal.mat')
        for i=1 : length(processdata.v)
            if processdata.v(i) > 3
                speedTest = true;
            end
        end
end


%% Conclusions:
if speedTest == true
    disp('Passed Speed Test')
else
    disp('Failed Speed Test')
end

%% Plots:
if selection == 1
    load('dataslow.mat')
elseif selection == 2
    load('dataerror.mat')
elseif selection == 3
    load('dataoptimal.mat')
end

figure(2)
plot(processdata.t, processdata.v, 'k', 'linewidth', 2), hold on

% Open source script to make plots more presentable:
title( ['Velocity over Time'] ,'interpreter', 'latex', 'fontsize', 16)
xlabel( '$t [s]$', 'interpreter', 'latex', 'fontsize', 16)
ylabel( '$V [m/s]$', 'interpreter', 'latex', 'fontsize', 16)
h = legend('$q_2$');
set(h, 'location', 'SouthEast', 'Interpreter', 'Latex', 'fontsize', 16 )
set(gca, 'TickLabelInterpreter','latex', 'fontsize', 16 )
set(gcf, 'PaperPositionMode', 'manual')
set(gcf, 'Color', [1 1 1])
set(gca, 'Color', [1 1 1])
set(gcf, 'PaperUnits', 'centimeters')
set(gcf, 'PaperSize', [15 15])               % Code acquired from ...  
set(gcf, 'Units', 'centimeters' )            %"MathWorks Plot Gallery Team"
set(gcf, 'Position', [0 0 15 15])
set(gcf, 'PaperPosition', [0 0 15 15])
