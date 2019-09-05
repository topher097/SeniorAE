import matplotlib.pyplot as plt
import numpy as np
from sympy import S, Symbol
import sympy

'''PART A'''
# Crete arrays from data
x_loc = np.array([0.0, .5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10])
p = np.array([145.04, 145.04, 145.04, 145.04, 145.03, 145.00, 144.93, 144.77, 144.44, 143.83, 142.77, 141.02, 138.27,
              134.10, 127.97, 119.22, 107.02, 90.34, 67.96, 38.42, 7.26])

# Create polynomial fit
z = np.polyfit(x_loc, p, 6)
# Create data points to plot
x2 = np.linspace(0, 10, num=100)
f = np.poly1d(z)        # Interpolation of pressure at certain x
print(z)
p2 = f(x2)

# Create latex legend for polynomial
x = Symbol('x')
poly = sum(S("{:6.2f}".format(v))*x**i for i, v in enumerate(z[::-1]))
eq_latex = 'p =' + str(sympy.printing.latex(poly))
print(eq_latex)

# Plot data and fitted polynomial
plt.plot(x2, p2, 'b', label="${}$".format(eq_latex))
plt.plot(x_loc, p, 'ro')
plt.legend(fontsize='small')
plt.title('AE433 - Homework 1a')
#plt.show()

'''PART B'''
# Find axial thrust by shear of fluid on walls of nozzle (planar, 1m depth)
# Define equations of the upper and lower walls of nozzle
y_up = 0.5 * x ** 0.6532
y_low = - y_up

# Get the normal vector at position along top and bottom surface by taking opposite reciprocal of slope
normal_eq_up = -1 * sympy.diff(y_up, x)
normal_eq_low = -1 * sympy.diff(y_low, x)
x2_list = x2.tolist()

for i in range(0, len(x2_list)):
    pos = i
    pressure = f(pos)

    # Upper surface
    dir_up = normal_eq_up.subs(x, x2_list[i])
    mag_up = (dir_up**2 + 1)**.5
    unit_up = [dir_up/mag_up, 1/mag_up]
    s_up = 1

    # Lower surface
    dir_low = normal_eq_low.subs(x, x2_list[i])
    mag_low = (dir_low**2 + 1)**.5
    unit_low = [dir_low/mag_low, 1/mag_low]
    s_low = 1

    # Front surface

