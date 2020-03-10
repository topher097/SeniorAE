syms t
denom = -C*inv(A-B*K)*B
kRef = 1/denom
Am = (A-B*K)
Ami = inv(Am)
P = expm(Am*(t))*x0
Q = Ami*expm(Am*(t))*(B*kRef*r + B*d)
R = -(Ami*(B*kRef*r + B*d))
x_t = P+Q+R
y_t = C*x_t