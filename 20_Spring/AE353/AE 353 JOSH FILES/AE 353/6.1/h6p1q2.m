Ac = A - L*C;
e0 = xhat0 - x0

e_t = expm(Ac*(t1-t0))*e0

mat2str(e_t)