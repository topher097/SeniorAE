% (a) less than 15% overshoot
% (b) rise time greater than 4 s and less than 6 s
% (c) zero steady-state error for step inputs.

load('GroupP.mat')

num=[wn^2];
den=[1 2*zeta*wn wn^2];
sys=tf(Km*num,den);
bode(sys)
%rltool(sys);

