"""
Cessna 182 Skylane, rectangular wing assumption. Span = 36ft, Area = 174 ft^2 (c = 4.83 ft), V_inf = 145 kts (245 fps).
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
from sympy import Symbol, sqrt
import matplotlib.pyplot as plt

class homeworkFive():
    # Initialize
    def __init__(self):
        # Variables and constants
        self.c_y = None             # Equation for chord distribution
        self.v_inf = 245            # freestream velocity (fps)
        self.span = 36              # wingspan (ft)
        self.S = 174                # wing area (ft^2)
        self.c_0 = 0                # root chord length (ft)
        self.N = 50                 # number of vortices along wing
        self.offset = 1*10**-6      # offset from wingtip (ft)
        self.alpha = np.deg2rad(8)  # alpha_g - alpha_zl
        self.wing_type = ''

        # Matrices
        self.Gamma = []         # List of (big) gamma's
        self.w = []             # List of downwash velocities (positive down)
        self.c_p = []           # Chord at control point P
        self.A = np.empty([self.N, self.N])
        self.b = np.empty([self.N, 1])
        self.x = np.empty([1, self.N])
        self.C_L = 0            # Lift coefficient distribution
        self.C_Di = 0           # Induced drag coefficient distribution]
        self.LD = 0             # Total L/D ratio

        # Run the rectangular wing
        homeworkFive.rectangularWing(self)
        # Run the elliptic wing
        homeworkFive.ellipticWing(self)

    def rectangularWing(self):
        self.wing_type = 'Rectangular'
        self.c_0 = 4.83
        y = Symbol('y')
        self.c_y = self.c_0 + 0*y          # Constant chord distribution along y
        homeworkFive.calcDownwash(self)

    def ellipticWing(self):
        self.wing_type = 'Elliptical'
        self.c_0 = (self.S * 4)/(np.pi * self.span)           # Root chord of wing
        y = Symbol('y')
        self.c_y = self.c_0 * sqrt(1 - 4*(y/self.span)**2)    # Equation of elliptical chord distribution
        homeworkFive.calcDownwash(self)

    def calcDownwash(self):
        self.c_p = []
        self.Gamma = []
        self.w = []
        # Discretize the wingspan by N panels
        y = Symbol('y')
        y_vp = (np.linspace(-self.span/2 + self.offset, self.span/2 - self.offset, self.N)).tolist()
        y_cp = []
        for i in range(len(y_vp) - 1):
            y_cp.append((y_vp[i+1] + y_vp[i])/2)
        self.c_p = []
        for y_c in y_cp:
            self.c_p.append(self.c_y.subs(y, y_c))
        # Define A matrix
        for i in range(0, self.N-1):
            c = self.c_p[i]
            y_c = y_cp[i]
            for j in range(0, self.N):
                if j <= i:
                    K = 1
                else:
                    K = 0
                y_v = y_vp[j]
                self.A[i][j] = K + c/(4*(y_c - y_v))
        for i in range(self.N):
            self.A[self.N-1][i] = 1
        #print(self.A)

        # Define the b matrix
        for i in range(self.N-1):
            c = self.c_p[i]
            self.b[i] = np.pi*self.v_inf*c*self.alpha
        self.b[self.N-1][0] = 0

        # Calc x matrix
        self.x = np.dot(np.linalg.inv(self.A), self.b)

        # Calc Gammas distribution
        x = np.transpose(self.x)[0].tolist()
        for i in range(0, self.N-1):
            gam = sum(x[0:i+1])
            self.Gamma.append(gam)

        # Calc downwash distribution
        for i in range(0, self.N-1):
            Gamma = self.Gamma[i]
            c = self.c_p[i]
            self.w.append((-Gamma/(c*np.pi))*(self.v_inf*self.alpha))
        print(self.w)

        # Calc lift and drag
        bp = abs(y_cp[1] - y_cp[0])
        self.C_L, self.C_Di = 0, 0
        for i in range(0, self.N-1):
            Gamma = self.Gamma[i]
            w = self.w[i]
            self.C_L += (Gamma*bp)/(0.5*self.v_inf*self.S)
            self.C_Di += (Gamma*bp*w)/(0.5*self.v_inf**2*self.S)
        self.LD = self.C_L/self.C_Di
        print(self.C_L)
        print(self.C_Di)
        print(self.LD)

        # Plot downwash distribution
        plt.figure()
        plt.plot(y_cp, self.w, color='k')
        plt.title(f'Downwash Distribution for {self.wing_type} Wing')
        plt.xlabel('y [ft]')
        plt.ylabel('w [ft/s]')
        plt.draw()





if __name__ == '__main__':
    # Run HW5
    hw5 = homeworkFive()
    plt.show()