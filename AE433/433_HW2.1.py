from numpy import *
from scipy import *

gamma = 1.4
R = 287             # J/kg*K
T1 = 288            # K
T2 = 451.31         # K
P1 = 101325         # N/m^2
P2 = 386376.886     # N/m^2
M1 = 3
M2 = 1.96213
h1 = tan(deg2rad(38))                                           # m
h2 = .5 * tan(deg2rad(20)) + (h1 - 1.5 * tan(deg2rad(20)))      # m
rho1 = P1/(R * T1)
rho2 = P2/(R * T2)
A1 = h1 * 1             # m^2
A2 = h2 * 1             # m^2


def vel(T, M):
    velocity = M * sqrt(gamma * R * T)
    return velocity


v1 = vel(T1, M1)
v2 = vel(T2, M2)
v2_x = v2 * cos(deg2rad(20))

# Part A
ThrustA = (rho1 * v1**2 * A1) - (rho2 * v2_x**2 * A2) + (P1 * A1) - (P2 * A2)
print(f'Axial Thrust (part a)= {ThrustA/1000} kN')              # 147.9703451259921 kN

# Part B
L1 = 1.5 / cos(deg2rad(20))
L2 = .5 / cos(deg2rad(20))

ThrustB = (P2 * sin(deg2rad(20)) * L1) - (P2 * sin(deg2rad(20)) * L2)
print(f'Axial Thrust (part b)= {ThrustB/1000} kN')              # Output = 140.62968571246572 kN


