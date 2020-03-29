%% AE 461 Lab 4
clc
clear all
close all

s3d = [0.001 0.010 0.019 0.029 0.038 0.059 0.077 0.097 0.118 0.138 0.158 0.177 0.197 0.217 0.235]; %deflection
s3load = [0 450 540 590 650 760 820 840 860 890 900 930 940 950 960]; % load
s4d = [0.000 0.010 0.020 0.029 0.039 0.058 0.079 0.098 0.117 0.139 0.158 0.177 0.198 .210 0.234];
s4load = [100 275 330 370 400 450 480 500 560 625 660 690 705 725 730];
s5d = [0.000 0.010 0.020 0.029 0.039 0.058 0.077 0.099 .117 0.138 0.150 0.177 0.198 0.216 0.2365];
s5load = [120 290 460 500 580 650 680 700 720 720 690 690 690 700 720];

sz1d = [0.000 0.010 0.018 0.029 0.038 0.060 0.078 0.098 0.118];
sz1load = [0 420 610 750 825 950 1000 1050 1120];
sz2d = [0.005 0.010 0.020 0.030 0.039 0.060 0.079 0.099 0.118];
sz2load = [0 75 160 240 300 400 580 740 860];

%% Force-Deflection Data for Demonstration Experiment
figure(1)
plot(s3d, s3load, '-o')
hold on
grid on
ylabel('Force [N]')
xlabel('Deflection [inches]')
legend('S3', 'Location', 'Best')
saveas(gcf, 'AE461Lab4Q1.jpg')

%% Question 3
close all
% theoretical values
s3loadt = 640.6*ones(length(s3load));
s3dt = s3d;
s5loadt = 470.65*ones(length(s5load));
s5dt = s5d;
% measured buckling values (max load during tests)
buck3 = max(s3load)*ones(length(s3load));
buck3d = s3d;
buck5 = max(s5load)*ones(length(s3load));
buck5d = s5d;

% Plot the data
figure(2)
set(gcf,'Position',[1000 100 900 600])
P = zeros(6,1);
P1 = plot(s3dt, s3loadt, 'LineStyle', '--','Linewidth',1.5); hold on; grid on;
P2 = plot(buck3d, buck3, 'Linestyle', '-.','Linewidth',1.5); hold on;
P3 = plot(s3d, s3load, 'LineStyle','-', 'Marker', 'o','Linewidth',1); hold on;
P4 = plot(s5dt, s5loadt, 'LineStyle', '--','Linewidth',1.5); hold on;
P5 = plot(buck5d, buck5, 'Linestyle', '-.','Linewidth',1.5); hold on;
P6 = plot(s5d, s5load, 'LineStyle', '-', 'Marker', 'o','Linewidth',1); hold off;

xlabel('Deflection [inches]')
ylabel('Load [N]')
legendnames = {'S3 Theoretical Buckling Load', 'S3 Actual Buckling Load', 'S3 Deflection Data', 'S5 Theoretical Buckling Load', 'S5 Actual Buckling Load', 'S5 Deflection Data'};
hand = [P1; P2; P3; P4; P5; P6];
size(legendnames);
legend(hand, legendnames, 'Location', 'eastoutside');
saveas(gcf, 'AE461Lab4Q3.jpg')

%% Question 4
figure(3)
plot(sz1d, sz1load,'-o', sz2d, sz2load, '-s')
hold on 
grid on
ylabel('Load [N]')
xlabel('Deflection [inches]')
legend('SZ1', 'SZ2', 'Location', 'Best')
saveas(gcf, 'AE461Lab4Q4.jpg')

