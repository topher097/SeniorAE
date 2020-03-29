denom = -C*inv(A-B*K)*B
kRef = 1/denom
Am = (A-B*K)
Ami = inv(Am)
P = expm(Am*(t1-t0))*x0
Q = Ami*expm(Am*(t1-t0))*(B*kRef*r + B*d)
R = -(Ami*(B*kRef*r + B*d))
x_t = P+Q+R
y_t = C*x_t
mat2str(x_t)
mat2str(y_t)