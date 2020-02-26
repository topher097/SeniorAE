%% Prob 1
clc;
clear all;
A = [0.70 0.70 0.20 0.90; -0.70 0.90 0.30 0.40; 0.30 0.80 -0.80 0.60; -0.80 -0.70 0.00 0.40];
B = [0.90; -0.60; 0.90; 0.50];
C = [-0.90 -0.40 -0.20 -0.10];
D = [0.00];
p = [-5.86-3.22j -5.86+3.22j -9.71+0.00j -4.00+0.00j];
K = acker(A, B, p);
disp(mat2str(K,8));

%% Prob 2
A = [7.00 9.00; 9.00 10.00];
B = [1.00; 0.00];
C = [0.00 1.00];
D = [0.00];
pTime = 3.00;
pOver = 0.04;

sigma = -log(pOver)/pTime;

omega = pi/pTime;

p1 = -sigma+omega*1i;
p2 = -sigma-omega*1i;
disp(mat2str([p1, p2], 8));

%% Prob 3
A = [0.00 0.50; 0.50 0.90];
B = [1.00; 0.00];
C = [0.00 1.00];
D = [0.00];
pTime = 3.20;
pOver = 0.40;

sigma = -log(pOver)/pTime;

omega = pi/pTime;

p1 = -sigma+omega*1i;
p2 = -sigma-omega*1i;

K = acker(A,B,[p1 p2]);
disp(mat2str(K, 8));
kRef = -1/(C*inv(A-B*K)*B);
disp(kRef);

%% Prob 4
A = [-0.59433830 -0.57182688 -1.10259050; -1.38605996 -6.91341636 -3.60342439; -0.09275109 -2.33596333 -1.49224534];
B = [-0.06631083; -1.01820149; -0.46677253];
C = [4.70189537 -1.57012896 2.75706257];
D = [0.00000000];
pTime = 4.20000000;
pOver = 0.21000000;

sigma = -log(pOver)/pTime; 

omega = pi/pTime;

p1 = -sigma+omega*1i;
p2 = -sigma-omega*1i;

K = acker(A,B,[p1 p2 -sigma]);
kRef = -1/(C*inv(A-B*K)*B);

info = stepinfo(ss(A-B*K,B*kRef,C,0), 'SettlingTimeThreshold',0.05);
p_time1 = info.PeakTime;
p_over1 = info.Peak-1;

K2 = acker(A,B,[p1 p2 -sigma*10]);
kRef2 = -1/(C*inv(A-B*K2)*B);
    
info2 = stepinfo(ss(A-B*K2,B*kRef2,C,0), 'SettlingTimeThreshold',0.05);
p_time2 = info2.PeakTime;
p_over2 = info2.Peak-1;

disp(p_time1);
disp(p_over1);
disp(p_time2);
disp(p_over2);

%% Prob 5
clc;
clear;

A = [0.20 -0.30; 0.30 -0.70];
B = [-1.00; -0.40];
C = [-0.20 -0.30];
D = [0.00];
pTime = 1.80;
pOver = 0.11;

sigma = -log(pOver)/pTime;

omega = pi/pTime;

p1 = -sigma+omega*1i+1.8;
p2 = -sigma-omega*1i-1.77;

K = acker(A,B,[p1 p2]);
kRef = -1/(C*inv(A-B*K)*B);

info = stepinfo(ss(A-B*K,B*kRef,C,0), 'SettlingTimeThreshold',0.05);
p_time1 = info.PeakTime;
p_over1 = info.Peak-1;
disp(p_time1);
disp(p_over1);

disp(mat2str(K, 8));
disp(kRef);

%% Prob 6
clc;
clear all;

A = [0.60 -0.10 -0.50; -0.40 -0.80 0.50; -0.80 -0.20 -0.80];
B = [0.00; 0.00; 1.00];
C = [0.90 0.00 0.00];
D = [0.00];
pTime = 4.10;
pOver = 0.27;

sigma = -log(pOver)/pTime;

omega = pi/pTime;

p1 = -sigma+omega*1i;
p2 = -sigma-omega*1i;

K = acker(A,B,[p1 p2 -sigma*2.75]);
kRef = -1/(C*inv(A-B*K)*B);

info = stepinfo(ss(A-B*K,B*kRef,C,0), 'SettlingTimeThreshold',0.05);
p_time1 = info.PeakTime;
p_over1 = info.Peak-1;
disp(p_time1);
disp(p_over1);
disp(mat2str(K, 8));
disp(kRef);

