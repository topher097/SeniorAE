import scipy.interpolate
import matplotlib.pyplot as plt
import numpy as np
from sympy import *
import sympy
from numpy.polynomial import polynomial as P

# Initiate the subplot
fig, ax = plt.subplots(nrows=2, ncols=1)

"""

KF DATA CALCULATIONS HERE (and A and B calcs)

"""

# Calculate kf
force_data = []
spin_data = []
with open('Kf_data.csv', 'rt') as kf:
    next(kf)
    for line in kf:
        data = line.split(',')
        if float(data[0]) > 27.5:
            break
        if not data[4] == '':
            spin_data.append([float(data[3]), float(data[5])])
        force_data.append([float(data[0]), float(data[1]) + 0.442])


# Create interpolation function of the spin data
time = []
spin = []
for i in range(0, int(len(spin_data))):
    time.append(spin_data[i][0])
    spin.append(spin_data[i][1])

spin_interp = scipy.interpolate.CubicSpline(time, spin)

# Calculate the kf average
kf_total = 0
counter = 0
kf_time_plot = []
kf_spin_plot = []
kf_plot = []
for j in range(0, len(force_data)):
    time = force_data[j][0]
    force = force_data[j][1]
    spin = spin_interp(time) * 2*np.pi
    kf = force / spin ** 2

    kf_time_plot.append(time)
    kf_plot.append(kf)
    kf_spin_plot.append(spin)
    if not kf < -0.00001:
        counter += 1
        kf_total += kf

kf_avg = kf_total/counter
print(f'K_f avg = {round(kf_avg, 10)}')


"""

KM DATA CALCULATIONS HERE

"""

# Calculate km
torque_data = []
spin_data = []
with open('Km_data.csv', 'rt') as km:
    next(km)
    for line in km:
        data = line.split(',')
        if float(data[0]) > 25:
            break
        if not data[4] == '':
            spin_data.append([float(data[3]) - 2, float(data[5])])
        torque_data.append([float(data[0]), ((float(data[1]) + 0.442) * 0.013)])

# Create interpolation function of spin data
time = []
spin = []
for i in range(0, int(len(spin_data)/20)):
    time.append(spin_data[i*20][0])
    spin.append(spin_data[i*20][1])
spin_interp = scipy.interpolate.CubicSpline(time, spin)

# Calculate the km average
km_total = 0
counter = 0
km_time_plot = []
km_plot = []
for j in range(0, len(torque_data)):
    time = torque_data[j][0]
    torque = torque_data[j][1]
    spin = spin_interp(time) * 2*np.pi
    km = torque / spin ** 2
    if not km < -0.000002:
        counter += 1
        km_total += km
        km_plot.append(km)
        km_time_plot.append(time)
km_avg = km_total/counter
print(f'K_m avg = {round(km_avg, 12)}')



"""

PLOT DATA

"""

# Plot kf and kf avg
plt.subplots_adjust(hspace=.5)
plt.subplot(2, 1, 1)
plt.title('Kf vs. time')
plt.ylabel('Kf')
plt.xlabel('time (s)')
plt.grid()
plt.ticklabel_format(axis='both', style='sci', scilimits=(-2,2))
plt.plot(kf_time_plot, kf_plot, label='kf')
plt.plot(kf_time_plot, kf_avg * np.ones(len(kf_time_plot)), label='kf avg')
plt.legend()


# Plot km and km avg
plt.subplot(2, 1, 2)
plt.title('Km vs. time')
plt.ylabel('Km')
plt.xlabel('time (s)')
plt.grid()
plt.ticklabel_format(axis='both', style='sci', scilimits=(-2,2))
plt.plot(km_time_plot, km_plot, label='km')
plt.plot(km_time_plot, km_avg * np.ones(len(km_time_plot)), label='km avg')
plt.legend()
plt.show()
