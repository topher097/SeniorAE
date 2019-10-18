%% Clear workspace
clear
clc
close all

A = pi/8;
T = 50; % 3; 2; 1; 0.5;

%% Find equations of motion
[h, x, u, h_num, params] = ae483_01_findeoms();

%% Do control design
[K, x_e, u_e] = ae483_02_docontroldesign(h, x, u, h_num, params);

%% Simulate
[data] = ae483_03_simulate(h_num, K, x_e, u_e, A, T);

%% Visualize

% Parse data from simulation
t = data.t;
hp = data.x(1, :);

% These data only give us z position - create full dataset for the purpose
% of visualization by adding other states as all zeros.
o = [zeros(size(hp));   % <--- o1 is always zero
     zeros(size(hp));   % <--- o2 is always zero
     -2*ones(size(hp))];               % <--- o3 is from simulation
hy = zeros(size(hp));   % <--- hy is always zero
hp = hp;   % <--- hp is always zero
hr = zeros(size(hp));   % <--- hr is always zero

% Apply the code you all wrote
moviefile = [];     % <--- could give the name of a file to save a movie
                    %           of the visualization to, like 'test.mp4'
lab1_visualize(t, o, hy, hp, hr, moviefile); 

%%

ang_pitch = data.x(1,:)';
angvel_pitch = data.x(2,:)';
time = data.t';
u2 = [data.u'; 0];
pitch_desired = [data.xdes'; 0];
T = table(time, pitch_desired, ang_pitch, angvel_pitch, u2); 

%
figure(2)
plot(time, ang_pitch, '-b');
hold on
plot(time, pitch_desired, '-r');
legend('sim', 'desired')

figure(3)
[a,b] = ss2tf([0 1; 0 0]-([0; 250]*K), [0; 250]*K(1), [1 0], [0]);
sys = tf(a,b);
bode(sys)

fb = bandwidth(sys)
fb = fb/(2*pi)
fb = 1/fb

trans = tf(sys)