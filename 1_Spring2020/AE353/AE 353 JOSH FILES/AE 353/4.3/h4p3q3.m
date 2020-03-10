syms k1 k2 k3 real
K = [k1 k2 k3]
Am = A - B*K
c = charpoly(Am)
c = c(2:end)
e = eig(Am)
func1 = e(2) == pdes
func2 = e(3) == pdes
s = solve(func1,func2)
disp(s.k1)
disp(s.k2)
k3 = 1
s1 = vpa(subs(s.k1))
s2 = vpa(subs(s.k2))
K = double([s1 s2 k3])
mat2str(K)