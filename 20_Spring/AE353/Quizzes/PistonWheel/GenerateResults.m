%%
clear all;
close all;
clc;


alpha = 0.7;
syms add ad a tau
eq1 = tau == (1.8 + 14.4*sin(alpha)^2)*add + 0.4*ad + 14.4*ad^2*cos(alpha)*sin(alpha);

o = 1.2*cos(alpha)
m = [0.7; 0];



bm = 0.4;        % meters
rm = 0.2;        % meters
roadwidth = 3;  % meters
v_road = 1;   % guess
r_road = inf;     % guess
w_road = v_road/r_road;

syms a adot addot tau
input = [tau];
state = [a; adot];
eq1 = (tau - 0.4*adot - 14.4*adot^2*cos(a)*sin(a))/(1.8+14.4*sin(a)^2);
gdot = [adot; eq1];
g_numeric = matlabFunction(gdot,'vars',{[a; adot; addot; tau]});
equi = [0.7; 0; 0; 0]; 

opts = optimoptions(@fsolve,'Algorithm','levenberg-marquardt','display','off');
[g_sol, g_numeric_at_f_sol, exitflag] = fsolve(g_numeric,equi,opts);
equiPoints = g_sol;
xhat_guess = -equiPoints(1:end-1);
xhat_guess = [0;0];

A = double(subs(jacobian(gdot, state), [a; adot; addot; tau], g_sol));
B = double(subs(jacobian(gdot, input), [a; adot; addot; tau], g_sol));

d = 1.2*cos(a);
y = [d];

C = double(subs(jacobian(y, state), [a; adot; addot; tau], g_sol));

Qo = [1.80];
Ro = [1.40 -0.40; -0.40 2.70];
Qc = [1.40 0.35; 0.35 1.20];
Rc = [0.50];

K = lqr(A, B, Qc, Rc);
L = lqr(A', C', inv(Ro), inv(Qo))';

kRef = -1./(C*inv(A-B*K)*B);

% disp(sprintf('data.A = %s;', mat2str(A)));
% disp(sprintf('data.B = %s;', mat2str(B)));
% disp(sprintf('data.C = %s;', mat2str(C)));
% disp(sprintf('data.K = %s;', mat2str(K)));
% disp(sprintf('data.L = %s;', mat2str(L)));
% disp(sprintf('data.xhat = %s;', mat2str(xhat_guess)));
% disp(sprintf('data.x_e = %s;\n', mat2str(equiPoints)));
D= [0];
Am = A
Bm = B
Cm = C
Dm = D
[num, den] = ss2tf(Am,Bm,Cm,Dm)
t_ol_u_to_y = tf(num,den)

Am = A-B*K-L*C
Bm = L
Cm = -K
Dm = 0 
[num, den] = ss2tf(Am,Bm,Cm,Dm)
y_to_u = tf(num,den)

Am = A-B*K-L*C
Bm = B*kRef
Cm = -K
Dm = kRef
[num, den] = ss2tf(Am,Bm,Cm,Dm)
r_to_u = tf(num,den)

H = t_ol_u_to_y
G = -y_to_u
F = minreal(r_to_u / G)

timedelay = 4.43


delay = minreal(F*G*H*timedelay / (1+G*H*timedelay))
p = pole(delay)
real(p)
all(real(p)<0)

tStop = 1.98;
initial = [0.16; 0.01];
Simulator('Controller', 'display', true', 'tStop', tStop, 'initial', initial)