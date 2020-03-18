A = [0.90 -0.90 -0.90; -0.50 -0.90 0.20; -0.90 -0.30 0.60];
B = [0.00; 0.00; -0.90];
C = [0.80 0.00 0.00];
D = [0.00];
pTime = 2.90 + .9
pOver = 0.27 - .095
w = pi/pTime
s = log(pOver)/pTime
p2 = [(s) + w*i, (s) - w*i, s*10]
K2 = place(A,B,p2)
kRef2 = 1/(-C*inv(A-B*K2)*B)
sys2 = ss(A-B*K2,B,C,D)
stepinfo(sys2)