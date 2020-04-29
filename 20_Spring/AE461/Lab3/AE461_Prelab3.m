%% AE461 Prelab 3 Q5
clc;
clear all;

G = 5.6391 * 10^6;      % psi
sigma = G*150*10^-6;    % psi
alpha = deg2rad(0.10);  % rad/in

syms ro ri real
eq1 = (ro^4-ri^4)/((ro+ri)^2) == ((ro-ri)*sigma)/(G*alpha);

a = solve(eq1, [ro, ri]);

ro = vpa(double(a.ro(3)),5)     % inches
ri = vpa(double(a.ri(3)),5)     % inches

