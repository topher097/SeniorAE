import matplotlib.pyplot as plt
import numpy as np
from sympy import *
import sympy



# Data from matlab calculations:
data = [(400, 7.768093), (500, 9.984840), (600, 12.245524), (700, 14.522583), (800, 16.995706), (900, 19.156292),
        (1000, 21.508923), (1100, 23.812697), (1200, 26.851965), (1300, 27.654037), (1400, 30.175668)]
rpm = []        # rotations per minute
velocity = []   # m/s

for i in data:
    rpm.append(i[0])
    velocity.append(i[1])

velocity = np.array(velocity)
rpm = np.array(rpm)

# Create polynomial fit
v_interp = np.polyfit(rpm, velocity, 2)
rpm_space = np.linspace(350, rpm[-1] + 50, num=25)
v_function = np.poly1d(v_interp)
v_fit = v_function(rpm_space)

# Create latex legend for polynomial
x = Symbol('x')
poly = sum(S("{:6.3f}".format(v))*x**i for i, v in enumerate(v_interp[::-1]))
eq_latex = 'V =' + str(sympy.printing.latex(poly))
print(eq_latex)

# Plot data and fitted polynomial
plt.figure(0)
plt.plot(rpm_space, v_fit, 'b', label="${}$".format(eq_latex))
plt.plot(rpm, velocity, 'ro')
plt.legend(fontsize='small')
plt.title('Experiment 2 - Velocity w.r.t. RPM')
plt.ylabel('Velocity (m/s)')
plt.xlabel('RPM')
plt.show()