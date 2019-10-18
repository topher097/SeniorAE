clear all
close all
clc

data1 = readtable('Kf_data.csv','Headerlines',1);
spinratef = table2array(data1(:,6));

data2 = readtable('Km_data.csv','Headerlines',1);
spinratem = table2array(data2(:,6));

motorcommand = [];
spinratefiltered = [];

for i = 1:length(spinratef)
    if spinratef(i) > 23 & spinratef(i) < 24
        motorcommand = [motorcommand; 10];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
    elseif spinratef(i) > 30 & spinratef(i) < 31
        motorcommand = [motorcommand; 20];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 37 & spinratef(i) < 38
        motorcommand = [motorcommand; 30];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 43 & spinratef(i) < 44
        motorcommand = [motorcommand; 40];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 49 & spinratef(i) < 50
        motorcommand = [motorcommand; 50];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 55 & spinratef(i) < 56
        motorcommand = [motorcommand; 60];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 60.5 & spinratef(i) < 61.5
        motorcommand = [motorcommand; 70];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 67.5 & spinratef(i) < 68.5
        motorcommand = [motorcommand; 80];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 73.25 & spinratef(i) < 74.25
        motorcommand = [motorcommand; 90];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 79.5 & spinratef(i) < 80.5
        motorcommand = [motorcommand; 100];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 86 & spinratef(i) < 87
        motorcommand = [motorcommand; 110];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 92 & spinratef(i) < 93
        motorcommand = [motorcommand; 120];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 97 & spinratef(i) < 98
        motorcommand = [motorcommand; 130];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 103.75 & spinratef(i) < 104.75
        motorcommand = [motorcommand; 140];
        spinratefiltered = [spinratefiltered; spinratef(i)];
        
     elseif spinratef(i) > 110 & spinratef(i) < 111
        motorcommand = [motorcommand; 150];
        spinratefiltered = [spinratefiltered; spinratef(i)];
    else
        continue
    end
end

for i = 1:length(spinratem)
    if spinratem(i) > 23 & spinratem(i) < 24
        motorcommand = [motorcommand; 10];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
    elseif spinratem(i) > 30 & spinratem(i) < 31
        motorcommand = [motorcommand; 20];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 37 & spinratem(i) < 38
        motorcommand = [motorcommand; 30];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 43 & spinratem(i) < 44
        motorcommand = [motorcommand; 40];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 49 & spinratem(i) < 50
        motorcommand = [motorcommand; 50];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 55 & spinratem(i) < 56
        motorcommand = [motorcommand; 60];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 60.5 & spinratem(i) < 61.5
        motorcommand = [motorcommand; 70];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 67.5 & spinratem(i) < 68.5
        motorcommand = [motorcommand; 80];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 73.25 & spinratem(i) < 74.25
        motorcommand = [motorcommand; 90];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 79.5 & spinratem(i) < 80.5
        motorcommand = [motorcommand; 100];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 86 & spinratem(i) < 87
        motorcommand = [motorcommand; 110];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 92 & spinratem(i) < 93
        motorcommand = [motorcommand; 120];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 97 & spinratem(i) < 98
        motorcommand = [motorcommand; 130];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 103.75 & spinratem(i) < 104.75
        motorcommand = [motorcommand; 140];
        spinratefiltered = [spinratefiltered; spinratem(i)];
        
     elseif spinratem(i) > 110 & spinratem(i) < 111
        motorcommand = [motorcommand; 150];
        spinratefiltered = [spinratefiltered; spinratem(i)];
    else
        continue
    end
end

spinratefiltered = 6.28*spinratefiltered;

P = polyfit(motorcommand, spinratefiltered, 1)
x = linspace(1,150,151);
y = P(1)*x + P(2);

hold on
title('spin rates vs motor command')
grid on
grid minor
xlabel('motor command')
ylabel('spin rate [rad/s]')
plot(x,y,'r')
scatter(motorcommand,spinratefiltered,'b')
legend('3.84x + 117')
hold off

