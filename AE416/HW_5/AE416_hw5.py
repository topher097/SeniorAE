"""
Cessna 182 Skylane, rectangular wing assumption. Span = 36ft, Area = 174 ft^2 (c = 4.83 ft).
Assume untwisted planform, angle of attack relative to zero-lift line (alpha_g-alpha_zl = 8 deg)
Using a finite vortex element method, model lifting line of wing. Define vortices to be slightly
in-board from the tips to avoid singularities.

a. Using N=500 shed vortex element locations across the span, solve for the shed circulation strengths
   gamma. With this distribution of gamma now known, calculate and plot the downwash distribution across the
   span, w(y).
b. Calculate and report the values of C_L, C_Di, and L/D_i for the rectangular wing configuration
c. Assume rectangular wing is replaced with geometrical elliptic wing of same area and span. Recall
   S=(pi*c_0*b)/4, where c_0 is the root chord. Under same conditions as rectangular wing, calculate and plot the
   downwash distribution across the span, w(y).
d. Calculate and report the values of C_L, C_Di, and L/D_i for elliptic wing configuration.
e. Commend on the difference or similarities between b. and d. Do the wings produce the same lift coefficients
   and the same L/D_i? Why or why not?
"""

import numpy as np
from sympy import Symbol
from math import *


class homeworkFive():
    # Initialize variables
    def __init__(self):
        self.c_y = 0        # Equation for chord distribution
        self.gamma = []     # List of gamma's
        self.w = []         # List of downwash velocities (positive down)
        self.b = 36         # span (ft)
        self.S = 174        # wing area (ft^2)
        self.c_0 = 0        # root chord length (ft)
        self.N = 500        # Number of vortices along wing

        # Run the rectangular wing
        homeworkFive.rectangularWing(self)
        # Run the elliptic wing
        homeworkFive.ellipticWing(self)

    def rectangularWing(self):
        self.c_0 = 4.83
        self.c_y = self.c_0         # Constant chord distribution along y
        # Calc gammas given c_y
        homeworkFive.calcGamma(self)

    def ellipticWing(self):
        self.c_0 = (self.S * 4)/(np.pi * self.b)
        Symbol('y')
        self.c_y = sqrt(self.c_0**2 * (1-4*(y/self.b)**2))      # Equation of elliptical chord distribution
        # Calc gammas given c_y
        homeworkFive.calcGamma(self)

    def calcGamma(self):
        pass

    def calcDownwash(self):
        pass

if __name__ == '__main__':
    # Run HW5
    hw5 = homeworkFive()