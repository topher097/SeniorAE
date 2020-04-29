import numpy as np
from sympy import Symbol, expand
import matplotlib.pyplot as plt

# Takes wing load from schrenks approximation and outputs interpolated equations for FEA on rear and front spar

# Define variables
y = []                      # Feet from center of aircraft of load
load = []                   # Schrenk loading (lbs)
load_rear = []              # Rear spar loading
load_front = []             # Front spar loading
front_mult = 0.80           # Front spar takes 75% of load
rear_mult = 1-front_mult
wing_root_offset = 6.9375   # Feet from center where spars start
mtow = 451000               # Max takeoff weight in pounds

# Extract the loading from csv file
with open('Wing Load.csv', 'r') as f:
    lines = f.readlines()[1:]
    for line in lines:
        line = line.split()
        y.append(float(line[0]))
        load.append(float(line[1]))
    f.close()

# Calculate the front and rear loading
load_front = [i*front_mult for i in load]
load_rear = [i*rear_mult for i in load]

# Adjust the arrays to start where the spars start (use offset)
index = 0
for i in y:
    if i - wing_root_offset >= 0:
        index = y.index(i)
        break
y_interp = y[index:]

# Create interpolation functions for front and rear loading
deg = 3
poly_rear = np.polyfit(y[index:], load_rear[index:], deg)
poly_front = np.polyfit(y[index:], load_front[index:], deg)
interfunc_rear = np.poly1d(poly_rear)
interfunc_front = np.poly1d(poly_front)

front_eq = ''
rear_eq = ''
poly_rear = list(reversed(list(poly_rear)))
poly_front = list(reversed(list(poly_front)))
for i in np.arange(0, deg+1, 1):
    front_eq += str(poly_front[i])
    rear_eq += str(poly_rear[i])
    for j in np.arange(0, i, 1):
        front_eq += '*"x"'
        rear_eq += '*"x"'
    if not i == deg and float(poly_front[i+1]) > 0:
        front_eq += '+'
    if not i == deg and float(poly_rear[i+1]) > 0:
        rear_eq += '+'

print('Front:')
print(front_eq)
print('Rear:')
print(rear_eq)

# Calculate the array for SW conversion
interp_rear = []
interp_front = []
front_error = []
rear_error = []
for i in y_interp:
    interp_rear.append(interfunc_rear(i))
    interp_front.append(interfunc_front(i))


print(f"Total Front Spar Force = {round(mtow*.5*front_mult, 0)} pounds")
print(f"Total Rear Spar Force = {round(mtow*.5*rear_mult, 0)} pounds")

# Calc error in interpolation function and the actual data
for i in y:
    front_error.append(load_front[y.index(i)] - interfunc_front(i))
    rear_error.append(load_rear[y.index(i)] - interfunc_rear(i))

# Plot functions to assure they are good interpolation functions
plot = plt.figure()
sub1 = plot.add_subplot(221)
sub1.plot(y_interp, interp_rear, ls='--', lw=1.2, c='b')
sub1.plot(y[::25], load_rear[::25], 'o', ms=3, c='b')

sub2 = plot.add_subplot(222)
sub2.plot(y_interp, interp_front, ls='--', lw=1.2, c='r')
sub2.plot(y[::25], load_front[::25], 'o', ms=3, c='r')

sub3 = plot.add_subplot(223)
sub3.plot(y, rear_error, ls='-', lw=1.2, c='k')
sub3.grid()

sub4 = plot.add_subplot(224)
sub4.plot(y, front_error, ls='-', lw=1.2, c='k')
sub4.grid()


plt.show()

