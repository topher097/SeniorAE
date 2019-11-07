from sympy import Symbol
import sympy
import numpy as np

import matplotlib.pyplot as plt


M = Symbol('M')
a = Symbol('a')
T_g = Symbol('T_g')
f = Symbol('f')
g = Symbol('g')

eq = M*a * ((T_g + f*T_g) * (1 + (g-1)/2 * M**2)**(-.5)-1)

#print(diff(eq), M)
#r = sympy.diff(eq, M) #, a, T_g, f, g)
#o = sympy.solve_linear(0, r, [M, a, T_g, f, g])
#print(r)
#print(o)

plt.figure()
x = []
y = []
for m in np.linspace(.01, 10, 100):
    sol = -2/(m**2*(1.4-1)) * ((m**2*.2 + 1)**.5 - (m**2*.2 + 1)**1.5)
    x.append(m)
    y.append(sol)

plt.plot(x, y, 'b')

plt.show()