%% Reset

clear;
clc;
clf;


%% Step response for different eigenvalue locations (exact, 2nd-order)

% Open-loop system
A = [0 1; 0 0];
B = [0; 1];
C = [1 0];

% Closed-loop eigenvalues
p = [-5-3*j -5+3*j];
color = 'b';

% Control design
K = acker(A, B, p);
kRef = -inv(C * inv(A - B * K) * B);

% Plot eigenvalues
subplot(1, 2, 1);
axis equal;
axis([-5 5 -5 5]);
grid on;
hold on;
plot(real(p), imag(p), 'kx', 'markersize', 8, 'linewidth', 2, 'color', color);
title('closed-loop eigenvalues');
set(gca, 'fontsize', 18);

% Plot step response
% - reference signal
r = 1;
% - closed-loop system
Am = A - B * K;
Bm = B * kRef;
Cm = C;
um = r;
% - simulation
x0 = [0; 0];
tmax = 5;
t = linspace(0, tmax, 1 + ceil(tmax / 1e-2));
x = zeros(2, length(t));
for i = 1:length(t)
    x(:, i) = expm(Am * t(i)) * x0 + inv(Am) * (expm(Am * t(i)) - eye(size(Am))) * Bm * um;
end
ym = Cm * x;
% - output
y = ym;
% - plot
subplot(1, 2, 2);
plot(t, y, '-', 'linewidth', 2, 'color', color);
axis([0 tmax 0 2]);
grid on;
hold on;
title('step response');
set(gca, 'fontsize', 18);

% Show peak time and peak overshoot
specs = stepinfo(ss(Am, Bm, Cm, 0), 'SettlingTimeThreshold', 0.05);
pTime = specs.PeakTime;
pOver = specs.Overshoot * 0.01;
fprintf(1, 'pTime: %g\n', pTime);
fprintf(1, 'pOver: %g\n\n', pOver);


%% How to derive the rules of thumb
clc
clear all

% Open-loop system
A = [0 1; 0 0];
B = [0; 1];
C = [1 0];

% Characteristic polynomial that would put eigenvalues at
%   -sigma + j * omega, - sigma - j * omega
syms sigma omega real
syms s
expand((s - (-sigma + j * omega)) * (s - (-sigma - j * omega)))

% Characteristic polynomial in terms of k1, k2
syms k1 k2 real
K = [k1 k2];
det(s * eye(2) - (A - B * K))

% Equate coefficients (by hand) to find k1, k2 that would put eigenvalues at
%   -sigma + j * omega, - sigma - j * omega
k1 = omega^2 + sigma^2;
k2 = 2 * sigma;
K = [k1 k2];

% Compute kRef for zero steady-state error in reference tracking
kRef = 1 / (-C * inv(A - B * K) * B);

% Compute step response (with zero disturbance)
syms t real
Am = A - B * K;
Bm = B * kRef;
Cm = C;
x0 = [0; 0];
um = 1;
xm = expm(Am * t) * x0 + inv(Am) * (expm(Am * t) - eye(size(Am))) * Bm * um;
ym = Cm * xm;
y = simplify(ym)

% "Peak" is when dy/dt = 0. First, find dy/dt:
ydot = simplify(diff(y, t))

% Then, solve (by hand) to find the smallest value of t > 0 that makes
% dy/dt = 0, this is peak time:
Tp = pi / omega
simplify(subs(ydot, t, Tp))

% Then, find (y(Tp) - 1) to find peak overshoot:
Mp = simplify(subs(y, t, Tp) - 1)



%% Reset

clear;
clc;
clf;


%% Step response for different eigenvalue locations (exact, 2nd-order) - with rules of thumb

% Open-loop system
A = [0 1; 0 0];
B = [0; 1];
C = [1 0];

% Closed-loop eigenvalues
Tp = 1.0;
Mp = 0.3;
omega = pi / Tp;
sigma = -log(Mp) / Tp;
p = [-sigma + omega * j, -sigma - omega * j];
color = 'm';

% Control design
K = acker(A, B, p);
kRef = -inv(C * inv(A - B * K) * B);

% Plot eigenvalues
subplot(1, 2, 1);
axis equal;
axis([-5 5 -5 5]);
grid on;
hold on;
plot(real(p), imag(p), 'kx', 'markersize', 8, 'linewidth', 2, 'color', color);
title('closed-loop eigenvalues');
set(gca, 'fontsize', 18);

% Plot step response
% - reference signal
r = 1;
% - closed-loop system
Am = A - B * K;
Bm = B * kRef;
Cm = C;
um = r;
% - simulation
x0 = [0; 0];
tmax = 5;
t = linspace(0, tmax, 1 + ceil(tmax / 1e-2));
x = zeros(2, length(t));
for i = 1:length(t)
    x(:, i) = expm(Am * t(i)) * x0 + inv(Am) * (expm(Am * t(i)) - eye(size(Am))) * Bm * um;
end
ym = Cm * x;
% - output
y = ym;
% - plot
subplot(1, 2, 2);
plot(t, y, '-', 'linewidth', 2, 'color', color);
axis([0 tmax 0 2]);
grid on;
hold on;
title('step response');
set(gca, 'fontsize', 18);

% Show peak time and peak overshoot
specs = stepinfo(ss(Am, Bm, Cm, 0), 'SettlingTimeThreshold', 0.05);
pTime = specs.PeakTime;
pOver = specs.Overshoot * 0.01;
fprintf(1, 'pTime: %g\n', pTime);
fprintf(1, 'pOver: %g\n\n', pOver);


%% Reset

clear;
clc;
clf;


%% Step response for different eigenvalue locations (approximate, 2nd-order)

% Open-loop system
A = [0 1; 0 0];
B = [0.1; 1];
C = [1 0];

% Closed-loop eigenvalues
pTime = 1.15;
pOver = 0.1;
omega = pi / pTime;
sigma = -log(pOver) / pTime;
p = [-sigma + j * omega, -sigma - j * omega];
color = 'g';

% Control design
K = acker(A, B, p);
kRef = -inv(C * inv(A - B * K) * B);

% Plot eigenvalues
subplot(1, 2, 1);
axis equal;
axis([-5 5 -5 5]);
grid on;
hold on;
plot(real(p), imag(p), 'kx', 'markersize', 8, 'linewidth', 2, 'color', color);
title('closed-loop eigenvalues');
set(gca, 'fontsize', 18);

% Plot step response
% - reference signal
r = 1;
% - closed-loop system
Am = A - B * K;
Bm = B * kRef;
Cm = C;
um = r;
% - simulation
x0 = [0; 0];
tmax = 5;
t = linspace(0, tmax, 1 + ceil(tmax / 1e-2));
x = zeros(2, length(t));
for i = 1:length(t)
    x(:, i) = expm(Am * t(i)) * x0 + inv(Am) * (expm(Am * t(i)) - eye(size(Am))) * Bm * um;
end
ym = Cm * x;
% - output
y = ym;
% - plot
subplot(1, 2, 2);
plot(t, y, '-', 'linewidth', 2, 'color', color);
axis([0 tmax 0 2]);
grid on;
hold on;
title('step response');
set(gca, 'fontsize', 18);

% Show peak time and peak overshoot
specs = stepinfo(ss(Am, Bm, Cm, 0), 'SettlingTimeThreshold', 0.05);
pTime = specs.PeakTime;
pOver = specs.Overshoot * 0.01;
fprintf(1, 'pTime: %g\n', pTime);
fprintf(1, 'pOver: %g\n\n', pOver);


%% Reset

clear;
clc;
clf;


%% Step response for different eigenvalue locations (approximate, 3rd-order)

% Open-loop system
A = [0 1 0; 0 0 1; 0 0 0];
B = [0; 0; 1];
C = [1 0 0];

% Closed-loop eigenvalues
pTime = 1;
pOver = 0.1;
omega = pi / pTime;
sigma = -log(pOver) / pTime;
p = [-sigma + j * omega, -sigma - j * omega, -sigma];
color = 'k';

% Control design
K = acker(A, B, p);
kRef = -inv(C * inv(A - B * K) * B);

% Plot eigenvalues
subplot(1, 2, 1);
axis equal;
axis([-15 5 -5 5]);
grid on;
hold on;
plot(real(p), imag(p), 'kx', 'markersize', 8, 'linewidth', 2, 'color', color);
title('closed-loop eigenvalues');
set(gca, 'fontsize', 18);

% Plot step response
% - reference signal
r = 1;
% - closed-loop system
Am = A - B * K;
Bm = B * kRef;
Cm = C;
um = r;
% - simulation
x0 = [0; 0; 0];
tmax = 5;
t = linspace(0, tmax, 1 + ceil(tmax / 1e-2));
x = zeros(size(x0, 1), length(t));
for i = 1:length(t)
    x(:, i) = expm(Am * t(i)) * x0 + inv(Am) * (expm(Am * t(i)) - eye(size(Am))) * Bm * um;
end
ym = Cm * x;
% - output
y = ym;
% - plot
subplot(1, 2, 2);
plot(t, y, '-', 'linewidth', 2, 'color', color);
axis([0 tmax 0 2]);
grid on;
hold on;
title('step response');
set(gca, 'fontsize', 18);

% Show peak time and peak overshoot
specs = stepinfo(ss(Am, Bm, Cm, 0), 'SettlingTimeThreshold', 0.05);
pTime = specs.PeakTime;
pOver = specs.Overshoot * 0.01;
fprintf(1, 'pTime: %g\n', pTime);
fprintf(1, 'pOver: %g\n\n', pOver);
