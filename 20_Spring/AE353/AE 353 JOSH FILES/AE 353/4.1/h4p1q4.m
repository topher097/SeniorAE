w = pi/pTime
s = log(pOver)/pTime
p1 = [(s) + w*i, (s) - w*i, s]
p2 = [(s) + w*i, (s) - w*i, s*10]
K1 = place(A,B,p1)
K2 = place(A,B,p2)
kRef1 = 1/(-C*inv(A-B*K1)*B)
kRef2 = 1/(-C*inv(A-B*K2)*B)
sys1 = ss(A-B*K1,B,C,D)
sys2 = ss(A-B*K2,B,C,D)
stepinfo(sys1)
stepinfo(sys2)