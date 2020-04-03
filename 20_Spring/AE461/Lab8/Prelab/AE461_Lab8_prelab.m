wn = 5;
zeta = 0.5;
num = [wn^2];
den = [1 2*zeta*wn wn^2];
sys = tf(num, den);

rltool(sys)


wn = 3.5480;
km = mean([0.00647 0.0270 0.0410 0.0510 0.0590 0.0660 0.0690]);
sys = tf(km*num, den);