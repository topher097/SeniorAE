pOver = 0.1100 - 0.02
pTime = 4.7000 + 1.05
w = pi/pTime
s = log(pOver)/pTime
p = [(s) + w*i, (s) - w*i]
mat2str(p)
K = place(A,B,p)
mat2str(K)
kRef = 1/(-C*inv(A-B*K)*B)
Am = A - B * K;
sys = ss(Am,B,C,D);
stepinfo(sys)