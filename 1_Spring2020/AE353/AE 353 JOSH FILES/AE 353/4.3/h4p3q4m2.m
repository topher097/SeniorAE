syms u3 u1 u2 real
Am = A
Bm = B
t = h

x1 = expm(Am*t)*x0 + inv(Am)*expm(Am*t)*Bm*u1 - inv(Am)*Bm*u1

x2 = expm(Am*t)*x1 + inv(Am)*expm(Am*t)*Bm*u2 - inv(Am)*Bm*u2

x3 = expm(Am*t)*x2 + inv(Am)*expm(Am*t)*Bm*u3 - inv(Am)*Bm*u3

func = x3==xn
s = solve(func)
disp(vpa(s.u1,6))
disp(vpa(s.u2,6))
disp(vpa(s.u3,6))