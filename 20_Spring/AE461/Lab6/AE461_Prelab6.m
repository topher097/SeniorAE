%% Prelab 6
clc;
clear all;
close all;

%% Problem 2
% For T300/5208 graphite/epoxy composite, construct a plot of Q_11 versus
% laminate orientation angle theta
Ex = 181;    % GPa
Ey = 10.3;     % GPa
Gxy = 7.17;     % GPa
vxy = 0.28;
c = (1-vxy^2*(Ey/Ex))^-1;
Qm11 = c*Ex;
Qm22 = c*Ey;
Qm12 = c*vxy*Ey;
Qm66 = Gxy;

theta = linspace(0, pi/2, 10000);
Q_11 = zeros(1, 10000);
theta_d = zeros(1, 10000);
figure(1)
for i = 1:length(theta)
    m = cos(theta(i));
    n = sin(theta(i));
    Q_11_i = m^4*Qm11 + n^4*Qm22 + 2*m^2*n*2*Qm12 + 4*m^2*n^2*Qm66;
    Q_11(1,i) = Q_11_i;
    theta_d(:,i) = 180/pi * theta(i);
end
plot(theta_d, Q_11)
grid on
xlabel('$$\Theta$$ (degrees)', 'interpreter', 'latex', 'fontsize', 16);
ylabel('$$Q_{11}$$ (GPa)', 'interpreter', 'latex', 'fontsize', 16)
title('$$Q_{11}$$ vs. $$\Theta$$', 'interpreter', 'latex', 'fontsize', 20)
saveas(1, 'Problem2.png')

%a: For what theta will the composite longitudinal stiffness be at half the
%theta = 0 degrees value? 1/3 the value?
Q_11_0 = Q_11(1,1)
Q_11_0_half = Q_11_0/2
Q_11_0_third = Q_11_0/3
half = false; third = false;
theta_half = 0; theta_third = 0;
for i = 1:length(Q_11)
    Q = Q_11(1,i);
    if half == false
        if Q <= Q_11_0_half
            theta_half = theta_d(i)
            half = true;
        end
    end
    if third == false
        if Q <= Q_11_0_third
            theta_third = theta_d(i)
            third = true;
        end
    end
end

%b: For what value of theta with the composite longitudinal stiffness drop
%by 10%?
Q_11_0_90 = Q_11_0 * .9
ninety = false; theta_ninety = 0;
for i = 1:length(Q_11)
    Q = Q_11(1,i);
    if ninety == false
        if Q <= Q_11_0_90
            theta_ninety = theta_d(i)
            ninety = true;
        end
    end
end

%% Problem 3
% What lamina orientation angle, theta, if any, yields a maximum value of
% Q_16 for T300/5208 graphite/epoxy?
Ex = 181;    % GPa
Ey = 10.3;     % GPa
Gxy = 7.17;     % GPa
vxy = 0.28;
c = (1-vxy^2*(Ey/Ex))^-1;
Qm11 = c*Ex;
Qm22 = c*Ey;
Qm12 = c*vxy*Ey;
Qm66 = Gxy;

theta = linspace(0, pi/2, 10000);
Q_16 = zeros(1, 10000);
Q_26 = zeros(1, 10000);
theta_d = zeros(1, 10000);
figure(2)
for i = 1:length(theta)
    m = cos(theta(i));
    n = sin(theta(i));
    Q_16_i = m^3*n*Qm11 - m*n^3*Qm22 + (m*n^3-m^3*n)*Qm12 + 2*(m*n^3-m^3*n)*Qm66;
    Q_16(1,i) = Q_16_i;
    Q_26_i = m*n^3*Qm11 - m^3*n*Qm22 + (-m*n^3+m^3*n)*Qm12 + 2*(-m*n^3+m^3*n)*Qm66;
    Q_26(1,i) = Q_26_i;
    theta_d(:,i) = 180/pi * theta(i);
end
plot(theta_d, Q_16, 'k'); hold on;
plot(theta_d, Q_26, 'b--');
grid on
legend({'$$Q_{16}$$', '$$Q_{26}$$'}, 'interpreter', 'latex', 'location', 'best', 'fontsize', 14)
xlabel('$$\Theta$$ (degrees)', 'interpreter', 'latex', 'fontsize', 16);
ylabel('$$Q$$ (GPa)', 'interpreter', 'latex', 'fontsize', 16)
title('$$Q$$ vs. $$\Theta$$', 'interpreter', 'latex', 'fontsize', 20)
saveas(2, 'Problem3.png')

% Find max values of Q16 and the associated theta value
Q16_max = max(Q_16)
Q16_max_index = find(Q_16==Q16_max);
Q16_max_theta = theta_d(1, Q16_max_index)

%% Problem 4
% From table F.2
X = 1500;
Xp = 1500;
Y = 40;
Yp = 246;
S = 68;
m = cos(15*pi/180);
n = sin(15*pi/180);

F1_l = 1/X - 1/Xp;
F2_l = 1/Y - 1/Yp;
F11_l = 1/(X*Xp);
F22_l = 1/(Y*Yp);
F12_l = -.5*sqrt(F11_l*F22_l);
F66_l = 1/(S^2);

F1 = n^2 * F2_l;
F11 = m^4*F11_l + n^4*F22_l + 2*m^2*n^2*F12_l + 4*m^2*n^2*F66_l;

% Solve for failure stress for compressive and tensile loads
syms o real
eq1 = 1 == F1*o + F11*o^2;
o_solve = vpa(solve(eq1, o), 8)
