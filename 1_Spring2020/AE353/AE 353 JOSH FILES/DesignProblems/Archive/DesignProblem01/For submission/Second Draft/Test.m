clear, close all, clc
DesignProblem01('Controller','datafile', 'Data.mat','display',false)

load('Data.mat')
figure(1)
plot(processdata.t, processdata.w1)
saveas(gcf,['w1_statefeedback.png']);

figure(2)
plot(processdata.t, processdata.w2)
saveas(gcf,['w2_statefeedback.png']);

figure(3)
plot(processdata.t, processdata.w3)
saveas(gcf,['w3_statefeedback.png']);