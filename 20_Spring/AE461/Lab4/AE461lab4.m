
clc
clear all
close all
%% AE 461 Lab 4
s3d = [0.001 0.010 0.019 0.029 0.038 0.059 0.077 0.097 0.118 0.138 0.158 0.177 0.197 0.217 0.235]; %deflection
s3load = [0 450 540 590 650 760 820 840 860 890 900 930 940 950 960]; % load
s4d = [0.000 0.010 0.020 0.029 0.039 0.058 0.079 0.098 0.117 0.139 0.158 0.177 0.198 .210 0.234];
s4load = [100 275 330 368 400 450 480 500 560 625 660 690 705 725 730];
s5d = [0.000 0.010 0.020 0.029 0.039 0.058 0.077 0.099 .117 0.138 0.150 0.177 0.198 0.216 0.2365];
s5load = [120 290 460 500 580 650 680 700 720 720 690 690 690 700 720];

sz1d = [0.000 0.010 0.018 0.029 0.038 0.060 0.078 0.098 0.118];
sz1load = [0 420 610 750 825 950 1000 1050 1120];
sz2d = [0.005 0.010 0.020 0.030 0.039 0.060 0.079 0.099 0.118];
sz2load = [0 75 160 240 300 400 580 740 860];

% Force-Deflection Data for Demonstration Experiment
figure(1)
plot(s3load, s3d, '-o')
hold on
grid on
xlabel('Force [N]')
ylabel('Deflection [inches]')
legend('S3', 'Location', 'Best')
saveas(gcf, 'Lab4Q1.jpg')

%% Question 3
clc;
% theoretical values
l = linspace(.1,1,1000);      % mm
E = 210 * 10^9;  % Pa
I_1 = (4.05^2 * 20.15)/12 * 10^-12;  % m^4
I_2 = (4.05^2 * 20.20)/12 * 10^-12;  % m^4
I_3 = (4.05^2 * 20.10)/12 * 10^-12;  % m^4
I_5 = (4.05^2 * 20.20)/12 * 10^-12;  % m^4

F_crit_1 = [];
F_crit_2 = [];
F_crit_3 = [];
F_crit_5 = [];

for i = 1:1000
    F_crit_1 = [F_crit_1, (pi^2*E*I_1)/(l(i)^2)];
    F_crit_2 = [F_crit_2, (pi^2*E*I_2)/(l(i)^2)];
    F_crit_3 = [F_crit_3, (pi^2*E*I_3)/(l(i)^2)];
    F_crit_5 = [F_crit_5, (pi^2*E*I_5)/(l(i)^2)];
end


figure(2)
plot(l.*1000, F_crit_1, '--');
grid on
xlabel('Rod Length [mm]')
ylabel('Buckling Load [N]')
legend({'Theoretical', 'Measured'}, 'Location', 'northeast');
saveas(gcf, 'Lab4Q3_S1.jpg')

figure(3)
plot(l.*1000, F_crit_2, '--');
grid on
xlabel('Rod Length [mm]')
ylabel('Buckling Load [N]')
legend({'Theoretical', 'Measured'}, 'Location', 'northeast');
saveas(gcf, 'Lab4Q3_S2.jpg')

figure(4)
plot(l.*1000, F_crit_3, '--');
grid on
xlabel('Rod Length [mm]')
ylabel('Buckling Load [N]')
legend({'Theoretical', 'Measured'}, 'Location', 'northeast');
saveas(gcf, 'Lab4Q3_S3.jpg')

figure(5)
plot(l.*1000, F_crit_5, '--');
grid on
xlabel('Rod Length [mm]')
ylabel('Buckling Load [N]')
legend({'Theoretical', 'Measured'}, 'Location', 'northeast');
saveas(gcf, 'Lab4Q3_S5.jpg')


%% Question 4
figure(6)
plot(sz1load, sz1d,'-o', sz2load, sz2d, '-s')
hold on 
grid on
xlabel('Load [N]')
ylabel('Deflection [inches]')
legend('SZ1', 'SZ2', 'SZ3', 'Location', 'Best')
saveas(gcf, 'Lab4Q4.jpg')

