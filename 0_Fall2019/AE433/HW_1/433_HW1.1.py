import matplotlib.pyplot as plt
import numpy as np
from sympy import *
import sympy
from scipy.integrate import quad
from scipy.misc import derivative

'''PART A'''
# Crete arrays from data
x_loc = np.array([0.0, .5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10])
p = np.array([145.04, 145.04, 145.04, 145.04, 145.03, 145.00, 144.93, 144.77, 144.44, 143.83, 142.77, 141.02, 138.27,
              134.10, 127.97, 119.22, 107.02, 90.34, 67.96, 38.42, 7.26])

# Create polynomial fit
z = np.polyfit(x_loc, p, 6)
# Create data points to plot
x2 = np.linspace(0, 10, num=100000)
f = np.poly1d(z)        # Interpolation of pressure at certain x
p2 = f(x2)

# Create latex legend for polynomial
x = Symbol('x')
poly = sum(S("{:6.2f}".format(v))*x**i for i, v in enumerate(z[::-1]))
eq_latex = 'p =' + str(sympy.printing.latex(poly))
print(eq_latex)

# Plot data and fitted polynomial
plt.figure(0)
plt.plot(x2, p2, 'b', label="${}$".format(eq_latex))
plt.plot(x_loc, p, 'ro')
plt.legend(fontsize='small')
plt.title('AE433 - Homework 1a')
plt.ylabel('Pressure (psia)')
plt.xlabel('Location (m)')
#plt.show()

'''PART B'''
# Find axial thrust by shear of fluid on walls of nozzle (planar, 1m depth), should be around 8000kN

# Get the normal vector at position along top and bottom surface by taking opposite reciprocal of slope
x2_list = x2.tolist()

# Calculate the thrust (integrate) along top surface and multiply by two because the top and bottom are symmetric
thrust = 0
y_up = 0.5 + x ** 0.6532
dz = np.linspace(0, 1, num=100)
dx = 10/len(x2_list)

def fun(x):
    return 0.5 + x ** 0.6532

def d_fun(x):
    h = 1e-5
    return np.real((fun(x+h)-fun(x-h))/(2*h))

# Plot vectors to make sure derivatives are computed correctly
plt.figure(1)
surface = lambdify(x, y_up, modules=['numpy'])
y_vals = []

def f(x):
    theta = np.arctan(-1/(0.6532/x**0.3468))
    unit_x = cos(theta)
    p_eq = (-.03*x**5 + 0.34*x**4 - 1.54*x**3 + 3.19*x**2 - 2.36*x + 145.26) * 6894.76

    return p_eq * unit_x * x/cos(np.pi/2 - theta)      # Returns the inner part of thrust integral with dl in terms of x

thrust_2 = quad(f, 0, 10)

print(thrust_2[0]*2/1000)





'''
for i in range(0, len(x2_list)):
    pressure = p2[i] * 6894.76                      # Pressure at location in N/m^2

    # Upper surface calculation
    pos = x2_list[i]
    y_vals.append(surface(pos))
    dir = -1/d_fun(pos)                             # Line that is collinear with normal vector
    theta_s = -1 * np.arctan(dir)                   # Find angle of line wrt x axis
    unit = [sin(theta_s), -1 * cos(theta_s)]        # Calculate the unit vector
    dl = dx / np.cos(np.pi/2 - theta_s)             # Calculate dl
    d_thrust = pressure * dl * abs(unit[1]) * 2     # Thrust for dl and dz in N (both top and bottom surface)
    thrust += d_thrust                              # Add d_thrust to total thrust

    # Plotting surface and normal vectors in order to validate correct normal vectors
    if i % 40 == 0:
        X = np.array((pos), dtype=float)
        Y = np.array((surface(pos)), dtype=float)
        U = np.array((unit[1]), dtype=float)
        V = np.array((unit[0]), dtype=float)
        plt.quiver(X, Y, U, V, color=['r', 'b', 'y'], units='xy', linewidth=-3, scale=2, headwidth=1.5)

# Thrust in kN
print(thrust/1000)

# Plots surface profile and shows both figures
plt.plot(x2_list, y_vals)
plt.show()
'''