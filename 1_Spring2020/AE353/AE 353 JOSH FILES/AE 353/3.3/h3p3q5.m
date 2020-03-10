kRef = 1 / (-C * inv(A - B * K) * B);
Am = [A - B * K, -B * kInt; C, 0];
Am2 = [A - B * K, -B * kInt; C, 0];
Bm = [B * kRef, B; -1, 0];
Bm2 = [B * kRef, B; -1, 0];
Cm = [C, 0];
um1 = [1; 0];
um2 = [1; 1];

sys = ss(Am,Bm*um1,Cm,D);
S1g = stepplot(sys)
S1 = stepinfo(sys,'settlingTimeThreshold',0.05);
disp(S1(1))

sys2 = ss(Am2,Bm2*um2,Cm,D);
S2g = stepplot(sys2)
S2 = stepinfo(sys2,'settlingTimeThreshold',0.05);
disp(S2(1))