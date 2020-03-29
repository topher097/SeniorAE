clear, clc
%% Insert Provided dataaaa:
tau = input('Tau = ');
w = input('Omega = ');
syms s
%% Calculations
tDelay = exp(-s*tau); tDelay = subs(tDelay, s, j*w);
tApprox = (2 - s*tau) / (2 + s*tau); tApprox = subs(tApprox, s, j*w);

tDelayMag = abs(tDelay)
tDelayAng = vpa(angle(tDelay))
tApproxMag = abs(tApprox)
tApproxAng = vpa(angle(tApprox))