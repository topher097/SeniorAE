clear all, close all, clc
%% Simulation
simulationCheck = input('1: Without disturbance | 2: With disturbance: ');

if simulationCheck == 1
    DesignProblem02('Controller', 'datafile', 'data.mat', 'initial', [0; 0; 0.02; 0.002] , 'display', true, 'diagnostics', true, 'disturbance', false, 'tStop', 20)
elseif simulationCheck == 2
    DesignProblem02('Controller', 'datafile', 'data.mat', 'initial', [0; 0; 0.02; 0.002] , 'display', true, 'diagnostics', true, 'disturbance', true, 'tStop', 20)
end


%% Plots:
load('Data.mat')
%Desired Piece-wise:
P1 = 0.0872665; %5 degrees
P2 = 0.174533;  %10 degrees
P3 = 0.261799;  %15 degrees
P4 =  0;        %0 degrees
tol = 0.0349066;

figure() 
plot(processdata.t, processdata.q2, 'k', 'linewidth', 2), hold on
yline(P1, '--r', 'linewidth', 2); hold on
yline(P2, '--g', 'linewidth', 2); hold on
yline(P3, '--b', 'linewidth', 2); hold on
%% Verification:
t = processdata.t;
q2 = processdata.q2;


truth = 0;
i = 0;
for i=1 : length(t)
    if (t(i) >= 0) && (t(i) <= 5)
        if abs(q2(i) - P1) <= tol
            truth = truth+1;
        end
    elseif (t(i) >= 5) && (t(i) <= 10)
        if abs(q2(i) - P2) <= tol
            truth = truth+1;
        end
    elseif (t(i) >= 10) && (t(i) <= 15)
        if abs(q2(i) - P3) <= tol
            truth = truth+1;
        end
    elseif (t(i) >= 15) && (t(i) <= 20)
        if abs(q2(i) - P4) <= tol
            truth = truth+1;
        end
    end
end
Accuracy = abs(truth/length(t))*100
if Accuracy >= 70
    disp('Verification complete: accurate results.')
else
    disp('Verification incomplete: inaccurate results.')
end

if simulationCheck == 2
    if Accuracy <= 70
        disp('We can see that our disturbance rejection did not work.')
    end
end

%% Open source script to make plots presentable:
title( ['Q2'] ,'interpreter', 'latex', 'fontsize', 16)
xlabel( '$t$', 'interpreter', 'latex', 'fontsize', 16)
ylabel( '$Angle$', 'interpreter', 'latex', 'fontsize', 16)
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
