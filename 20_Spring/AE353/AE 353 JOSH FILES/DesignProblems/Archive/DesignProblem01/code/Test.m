clear, close all, clc
%% Initialize simulation
DesignProblem01('Controller','datafile', 'Data.mat', 'display', true)

%% Plots
load('Data.mat')
plot(processdata.t, processdata.w1), hold on
plot(processdata.t, processdata.w2), hold on
plot(processdata.t, processdata.w3)

%% Open source script to make plots presentable
title( ['$\omega$'] ,'interpreter', 'latex', 'fontsize', 16)
xlabel( '$x$', 'interpreter', 'latex', 'fontsize', 16)
h = legend( '$\omega_1$', '$\omega_2$','$\omega_3$');
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


%% Save Plots
saveas(gcf,['zero_input_statefeedback.png']);
