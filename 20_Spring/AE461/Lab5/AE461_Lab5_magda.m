clc
clear all 
close all

%% AE461 Lab 5
load('GroupP-Lab5.mat')
% data is 16 different locations (vid shows 17 but 1 didn't work)
% b/c it was too close to the root
% spacing is L/17, start counting at unsupported end
% frequency data is the freqs at which we measured acceleration data
% from which we calculated linear amplitude
% data at each location:
%   [real part of response | imag part | linear amplitude(not squared) | phase}
% sqrt(real^2 + imag^2) = lin amplitude
% use data to find eigenvalues(eigenfrequencies)
% construct first 3 eigenmodes from this data
% TIP!!
% when you plot the eigenshape based on the imaginary part,
% not all 16 data files will be good
% if the plot is way off what the eigenshape should be, discard them
% (there is noise) not a lot of data, but you can discard a few data points
% this happens if you hit with the hammer and don't retract it right away,
% the hammer records the reflection of the wave
% hammer records multiple values and when it averages them it's off
% have to leave a gap for the data you exclude
data = {data16, data15, data14, data13, data12, data11, data10, ...
        data9, data8, data7, data6, data5, data4, data3, data2, data1};
L = 1;
spacing = L/17;
X = spacing*2:spacing:L;

%% Find peaks in imaginary part of data for first location
close all
modes = [5;36;102];%200;392]; % indices in frequencydata that correspond to natural frequencies
% TA told me these are the first 3 natural frequencies: 24 Hz, 148 Hz, 412 Hz 
% since frequencies were sampled every 4 Hz, these are the ones I used:
%          26 Hz
%          150
%          414
%          806
%         1574
% for i = 1:16
%     figure(i)
%     sig = data{i}(:,2);
%     [pks,locs] = findpeaks(abs(sig), 'MinPeakProminence',0.007);
%     [pks,freq] = findpeaks(abs(sig), frequencydata, 'MinPeakProminence',0.007);
%     plot(frequencydata, sig)
% %     ylim([-0.05, 0.45])
%     grid on
%     xlabel('Frequency [Hz]')
%     ylabel('Im(Amplitude)')
% %     title(['Imaginary Part for Location ' num2str(i)])
%     text(freq,sig(locs),num2str(freq))
% %     saveas(gcf, ['Imaginary Part for Location ' num2str(i) '.jpeg'])
% end
%% Calculate theoretical mode shapes (from prelab)
l = 1;%0.4572;
lambda = [1.8571; 4.6941; 7.8548]./l;
x = 0:0.0001:l;
c1 = 1;
c2 = -c1.*(sinh(lambda*l) + sin(lambda*l))./(cosh(lambda*l) + cos(lambda*l));
c3 = -c1;
c4 = c1.*(sinh(lambda*l) + sin(lambda*l))./(cosh(lambda*l) + cos(lambda*l));

W = c1*sinh(lambda.*x) + c2.*cosh(lambda.*x) + c3.*sin(lambda.*x) + c4.*cos(lambda.*x);
%% Plot Beam Shapes
for i = 1:16
    sig = data{i}(:,2);
    for j = 1:3
        beamshape(i,j) = sig(modes(j));   
    end
end
%% Plot beam shapes
indices = {[1:16], [1:16], [1:16]}; %used for ommiting data points
for j = 1:3
    shape = beamshape(:,j)./max(abs(beamshape(:,j)));
    shape = shape(indices{j});
    X = spacing*2:spacing:L;
    X = X(indices{j});
    figure(j*100)
    plot(X, shape, '-o')
%     xticks([0:round(spacing, 3):L])
    hold on
    plot(x/L, -W(j,:)./max(abs(W(j,:))))
    grid on
    xlabel('Length Along Beam x/L [in/in]')
    ylabel(['Normalized Peaks at Natural Frequency ' num2str(j)])
    legend('Experimental Mode Shape', 'Theoretical Mode Shape', 'Location', 'Best')
%             saveas(gcf, ['Beam Shape for Eigenmode ' num2str(j) '.jpeg'])
end

% figure()
% plot(x/L, W(1,:)./abs(min(W(1,:))))
% grid on
% hold on
% plot(x/L, W(2,:)./max(W(2,:)))
% plot(x/L, W(3,:)./abs(min(W(3,:))))
% xlabel('x/L')
% ylabel('Mode Shape W(x)')
% legend('\lambda_1','\lambda_2','\lambda_3', 'Location', 'Best')
% saveas(gcf, 'AE461_Prelab5_Q4.jpeg')





%% Beam Eigenfrequencies: Impact Hammer
% torsional mode at 60hz, torsional modes come after bending modes
% hitting off-center could be source of error? if torsional modes
% 148 is second bending mode



