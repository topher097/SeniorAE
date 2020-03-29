syms a b q r m x u p pdot n
f(x,u) = a*x + b*u
g(x,u) = (x^2)*q + (u^2)*r + 2*x*u*n
h(x) = (x^2)*m

dvdt = (x^2)*pdot
dvdx = 2*x*p

%HJB
left = dvdt
right = dvdx*f(x,u)+g(x,u)

minimumfunc = 0==diff(right,u)
minimizer = solve(minimumfunc,u)

u = minimizer
min = subs(right)

HJB = 0 == subs(left)+min
HJB = collect(HJB,(x^2))/(x^2)
PDOT = solve(HJB,pdot)

k = collect(-u,x)