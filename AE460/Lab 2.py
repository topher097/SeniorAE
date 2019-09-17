import matplotlib.pyplot as plt
import numpy as np
from sympy import *
from scipy.integrate import quad


# Data from matlab calculations:
data = [(400, ), (500, ), (600, ), (700, ), (800, ), (900, ), (1000, ), (1100, ), (1200, )]
rpm = []
velocity = []

for i in data:
    print
    rpm.append(i[0])
    velocity.append(i[1])

velocity = np.array(velocity)
rpm = np.array(rpm)

# Create polynomial fit
v_interp = np.polyfit(rpm, velocity, 2)
rpm_space = np.linspace(0, rpm[-1], num=25)
v_function = np.poly1d(v_interp)
v_fit = v_function(rpm_space)

# Create latex legend for polynomial
x = Symbol('x')
poly = sum(S("{:6.2f}".format(v))*x**i for i, v in enumerate(z[::-1]))
eq_latex = 'p =' + str(sympy.printing.latex(poly))
print(eq_latex)

# Plot data and fitted polynomial
plt.figure(0)
plt.plot(rpm_space, v_fit, 'b', label="${}$".format(eq_latex))
plt.plot(x_loc, p, 'ro')
plt.legend(fontsize='small')
plt.title('AE433 - Homework 1a')
plt.ylabel('Pressure (psia)')
plt.xlabel('Location (m)')
plt.show()