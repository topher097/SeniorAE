Am = A-B*K
Bm = B*[0] + B*[0]
sys = ss(Am,B,C,D);
S1 = stepinfo(sys,'settlingTimeThreshold',0.05)
%pause
Bm2 = B*[0] + B*1
sys2 = ss(Am,B,C,D);
S2 = stepinfo(sys2,'settlingTimeThreshold',0.05)
[y,t] = step(sys2);
sserror = abs(y(end))
stepplot(sys,sys2)
