syms k1 k2 k3 k4 k5 k6 
K = [k1 k2 k3;k4 k5 k6]
Am = A - B*K
q = eig(Am)
func = p==q
s = solve(func)