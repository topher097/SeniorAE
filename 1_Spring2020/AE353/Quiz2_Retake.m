clc;
clear all;
close all;

%%
clc;
clear all;

A = [0.60 0.10; 0.20 0.50];
B = [0.40; 0.00];
C = [0.80 -0.50];
D = [0.00];
p = [-6.44 -5.88];
K = acker(A, B, p);
disp(mat2str(K,8));



%%
clc;
clear all;

A1 = [9.3 5.3 6.7 -2.5; -33.9 -22.5 -32.6 12.4; 29.4 21.3 33.3 -12.9; 40.2 32.0 53.2 -20.8];
B1 = [-3.5; 13.4; -12.5; -18.1];
A2 = [5.5 34.7 -9.4 6.7; 6.9 133.6 -27.4 22.6; -12.8 -421.3 81.0 -69.3; -57.3 -1312.8 263.0 -219.8];
B2 = [-0.6; -3.0; 9.9; 29.9];
A3 = [-0.2 0.1; -0.4 0.2];
B3 = [0.1; 0.3];
A4 = [-0.3 -1.2; 0.0 0.0];
B4 = [-0.1; 0.0];
A5 = [-20.3 -2.3 -3.8 -15.7; 8.5 2.6 3.2 8.4; -51.3 -7.4 -11.2 -41.5; 38.4 4.4 7.2 29.7];
B5 = [-0.8; 0.3; -1.9; 1.5];

W1 = ctrb(A1,B1)
W2 = ctrb(A2,B2)
W3 = ctrb(A3,B3)
W4 = ctrb(A4,B4)
W5 = ctrb(A5,B5)

if rank(W1) == size(A1)
    disp('W1 yes')
else
    disp('W1 no')
end 

if rank(W2) == size(A2)
    disp('W2 yes')
else 
    disp('W2 no')
end 

if rank(W3) == size(A3)
    disp('W3 yes')
else 
    disp('W3 no')
end 

if rank(W4) == size(A4)
    disp('W4 yes')
else 
    disp('W4 no')
end

if rank(W5) == size(A5)
    disp('W5 yes')
else 
    disp('W5 no')
end

%%
clc;
clear all;

A = [0.60 -0.10 0.90; 0.10 -0.40 0.80; 1.00 -1.00 -0.60];
B = [0.80; 0.20; 0.80];
r = 3.40;
t0 = 1.00;
x0 = [-0.92; 0.94; 0.17];

Q = 1/r*eye(length(B));
Q1 = mat2str(Q,4);
R = [1];

[K,P] = lqr(A, B, Q, R);
disp(mat2str(K));


%%
clc;
clear all;

A = [0.7 0.0 0.9 0.9 -1.0; 0.3 0.4 0.3 -0.4 -0.3; -0.6 0.8 -0.2 -0.7 -0.9; -0.4 0.5 0.1 0.5 -0.1; 1.0 0.1 -0.5 0.0 -0.2];
B = [0.1; 0.5; -0.4; 0.8; -1.0];
p = [-7.0+3.0j -7.0-3.0j -5.0+3.0j -5.0-3.0j -1.0+0.0j];


%%
clc;
clear all;

A = [-0.10 0.70; -0.90 -0.60];
B = [-0.90; 0.60];
C = [-0.80 0.60];
D = [0.00];
pTime = 3.00;
pOver = 0.13;

sigma = -log(pOver)/pTime;

omega = pi/pTime;

p1 = -sigma+omega*1i+.95;
p2 = -sigma-omega*1i-.95;

K = acker(A,B,[p1 p2]);
kRef = -1/(C*inv(A-B*K)*B);

info = stepinfo(ss(A-B*K,B*kRef,C,0), 'SettlingTimeThreshold',0.05);
p_time1 = info.PeakTime;
p_over1 = info.Peak-1;
disp(p_time1);
disp(p_over1);

disp(mat2str(K, 8));
disp(kRef);




%%
clc;
clear all;

A = [0.00 1.00; 0.00 0.00];
B = [0.00; 1.00];
C = [1.00 0.00];
uMax = 3.10;

m = (1/uMax)^2

