%% Lab 8 Report, Question 4
clc;
clear all;
close all;
load('GroupP.mat')
bodeTheoretical = load('StepResponseRLTool.mat');
P = bodeoptions('cstprefs');
P.Grid = 'on';
[mag,phase,wout] = bode(bodeTheoretical.IOTransfer_r2y, P);
bandwidth = bandwidth(bodeTheoretical.IOTransfer_r2y)

%% 100
time_100 = freq_100(:,1);
in_100 = freq_100(:,2);
out_100 = freq_100(:,3);

figure(100)
plot(time_100, in_100, time_100, out_100)
legend('Input', 'Output','Location','southeast');
title('Input and Output Signal for 0.1 rad/sec')
xlabel('Time (s)')
ylabel('Amplitude (rad)')

diff_100 = [abs(0.4-0.4009); (0.4-0.3985)];
diff_100 = mean(diff_100);
saveas(100, '100.png')

%% 556
time_556 = freq_556(:,1);
in_556 = freq_556(:,2);
out_556 = freq_556(:,3);

figure(556)
plot(time_556, in_556, time_556, out_556)
legend('Input', 'Output','Location','southeast');
title('Input and Output Signal for 0.556 rad/sec')
xlabel('Time (s)')
ylabel('Amplitude (rad)')

diff_556 = [(0.4 - 0.3368); (0.4-0.377); (0.4-0.3757); (0.4-0.3745); (0.4 - 0.3745)];
diff_556 = mean(diff_556);
saveas(556, '556.png')

%% 750
time_750 = freq_750(:,1);
in_750 = freq_750(:,2);
out_750 = freq_750(:,3);

figure(750)
plot(time_750, in_750, time_750, out_750)
legend('Input', 'Output','Location','southeast');
title('Input and Output Signal for 0.75 rad/sec')
xlabel('Time (s)')
ylabel('Amplitude (rad)')

diff_750 = [(0.4 - 0.2915); (0.4 - 0.3594); (0.4-0.3581); (0.4-0.3569); (0.4-0.3569); (0.4-0.3581)];
diff_750 = mean(diff_750);
saveas(750, '750.png')

%% 1000
time_1000 = freq_1000(:,1);
in_1000 = freq_1000(:,2);
out_1000 = freq_1000(:,3);

figure(1000)
plot(time_1000, in_1000, time_1000, out_1000)
legend('Input', 'Output','Location','southeast');
title('Input and Output Signal for 1 rad/sec')
xlabel('Time (s)')
ylabel('Amplitude (rad)')
saveas(1000, '1000.png')

diff_1000 = [(0.4-0.3405); (0.4-0.3393); (0.4 - 0.3393); (0.4-0.3368); (0.4 - 0.3393)];
diff_1000 = mean(diff_1000);

%% 1500
time_1500 = freq_1500(:,1);
in_1500 = freq_1500(:,2);
out_1500 = freq_1500(:,3);

figure(1500)
plot(time_1500, in_1500, time_1500, out_1500)
legend('Input', 'Output','Location','southeast');
title('Input and Output Signal for 1.5 rad/sec')
xlabel('Time (s)')
ylabel('Amplitude (rad)')
saveas(1500, '1500.png')

diff_1500 = [(0.4-0.3079); (0.4-0.323); (0.4-0.3167); (0.4-0.323); (0.4-0.3217)];
diff_1500 = mean(diff_1500);

%% 3000
time_3000 = freq_3000(:,1);
in_3000 = freq_3000(:,2);
out_3000 = freq_3000(:,3);

figure(3000)
plot(time_3000, in_3000, time_3000, out_3000)
legend('Input', 'Output','Location','southeast');
title('Input and Output Signal for 3 rad/sec')
xlabel('Time (s)')
ylabel('Amplitude (rad)')
saveas(3000, '3000.png')

diff_3000 = [(0.4-0.3066); (0.4-0.3129); (0.4-0.3104); (0.4-0.3079); (0.4-0.3091)];
diff_3000 = mean(diff_3000);

%% magnitude for different frequencies in dB

frequencies = [100, 556, 750, 1000, 1500, 3000];

magnitude_100 = mag2db(diff_100);
magnitude_556 = mag2db(diff_556);
magnitude_750 = mag2db(diff_750);
magnitude_1000 = mag2db(diff_1000);
magnitude_1500 = mag2db(diff_1500);
magnitude_3000 = mag2db(diff_3000);

magnitude = abs([magnitude_100, magnitude_556, magnitude_750, magnitude_1000, magnitude_1500, magnitude_3000]);

% Find the value of dB near each frtequency
theory_mag = [];
freq_step = 1;
for i = 1:length(frequencies)
    freq = frequencies(i)/1000;
    for j = 1:length(wout)
        check = wout(j);
        if (freq - check) < 0
           theory_mag = [theory_mag check];
           break
        end
    end
end

figure(1)
hold on
x = wout;
y = squeeze(mag);
plot(x, y, 'b')
plot(frequencies/1000, magnitude/100, 'ro')
grid on
set(gca,'XScale','log','YScale','log')
title('Experimental and Theoretical Bode Magnitude')
xlabel('Freqency (rad/s)')
ylabel('Magnitude (dB)')
legend('Theoretical', 'Experimental', 'Location', 'best')
saveas(1, 'Bode.png')

%%  Create subplot
% % Load saved figures
% a = hgload('100.fig');
% b = hgload('556.fig');
% c = hgload('750.fig');
% d = hgload('1000.fig');
% e = hgload('1500.fig');
% f = hgload('3000.fig');
% 
% % Prepare subplots
% figure(5)
% h(1)=subplot(2,3,1);
% h(2)=subplot(2,3,2);
% h(3)=subplot(2,3,3);
% h(4)=subplot(2,3,4);
% h(5)=subplot(2,3,5);
% h(6)=subplot(2,3,6);
% 
% % Paste figures on the subplots
% copyobj(allchild(get(a,'CurrentAxes')),h(1));
% copyobj(allchild(get(b,'CurrentAxes')),h(2));
% copyobj(allchild(get(c,'CurrentAxes')),h(3));
% copyobj(allchild(get(d,'CurrentAxes')),h(4));
% copyobj(allchild(get(e,'CurrentAxes')),h(5));
% copyobj(allchild(get(f,'CurrentAxes')),h(6));
% legend('Input', 'Output', 'Location', 'best')
% 
% xlabel('Time (s)')
% ylabel('Amplitude (rad)')
% saveas(5, 'masterSubplot.png')