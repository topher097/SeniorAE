%make symbolic variables and symbolic K
syms k1 k2 k3 k4 k5 k6 real
K = [k1 k2 k3;k4 k5 k6]

%A - BK and characteristc polynomial
Am = A - B*K
c = charpoly(Am)
c = c(2:end)
a = poly(p)
a = a(2:end)
func = c==a

%solve in terms of k4 k5 k6
s = solve(func)
disp(s.k1)
disp(s.k2)
disp(s.k3)

%choose k4 k5 k6 and evaluate to get k1 k2 k3 for K1
k4 = 4
k5 = 5
k6 = 6
s1 = vpa(subs(s.k1))
s2 = vpa(subs(s.k2))
s3 = vpa(subs(s.k3))
K1 = [s1 s2 s3;k4 k5 k6]

%choose k4 k5 k6 and evaluate to get k1 k2 k3 for K2
k4 = 1
k5 = 2
k6 = 3
s1 = vpa(subs(s.k1))
s2 = vpa(subs(s.k2))
s3 = vpa(subs(s.k3))
K2 = [s1 s2 s3;k4 k5 k6]

%convert K1 and K2 to numeric matrices for printing to strings
K1 = double(K1)
K2 = double(K2)
mat2str(K1)
mat2str(K2)

%check that the eigenvalues match the requested one
eig(A - B*K1)
eig(A - B*K2)