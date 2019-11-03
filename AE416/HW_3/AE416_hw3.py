"""
AE 416 Homework 3

Main objective:
Write a vortex panel method solver for a 2d airfoil given:
- Chord length
- V infinity
- angle of attack
- Camber line profile

problem1:
- Predict the lift and quarter chord pitching moment characteristics of a flat plate from aoa -10 to 10 deg
    a. Compare results from calc using 20, 40, 60, and 80 panels
    b. Using 60 panels in your calculations, compare in a plot your solution (Cl and Cmc4 vs alpha) with the analytics
       solution for a flat plate
    c. Assuming that Gamma = gamma * ds (gamma const across panel), compare gamma dist. produced by the four panel
       dists. from part a. Where are the dists. consistent and different b/w these panel distributions

problem2:
- Predict the lift and quarter chord pitching moment characteristics, as well as the zero lift aoa, for an NACA 23012
  airfoil at aoa of 10 deg. The camberline dist. for this airfoil can be expressed as:
            yc = k/6(x^3 - 3mx^2 + m^2(3-m)x) for 0 < x < m
               = (km^3)/6 * (1-x) for m < x < 1
            where k = 15.957 and m = 0.2025
problem3:
- For NACA 23012 airfoil, calculate and plot the streamline at aoa of 10 deg, along with the plot of the airfoil in the
  flow. Plot should extend 3 chords upstream and downstream of the airfoil. Provide with plot of 1:1 scale of x and y.
"""

import numpy as np
import matplotlib.pyplot as plt
from sympy import Symbol
import os
import scipy.interpolate
from math import sqrt



class vortexPanels():

    # Initialize variables
    def __init__(self):
        self.master_panels = {}             # Dict of panel and their node coordinates, length, vortex location,
                                            # and control point location
        self.panel_num = 10                 # Number of panels in camberline
        self.v_inf = 0                      # Freestream velocity scalar (m/s)
        self.alpha = 0                      # Angle of attack (degrees)
        self.chord_length = 1               # Chord length of airfoil (m)

    # Solve the lumped vortex method given master coord dict, v_inf, and alpha
    def solvePanele(self):
        pass

    # Compute problem 1
    def problemOne(self):
        # Define the camber line in (x, y) point sets
        x = np.linspace(0, 1, self.panel_num)
        y = np.zeros(len(x))



        # Run panel solver
        vortexPanels.solvePanele(self)

    # Compute problem 2
    def problemTwo(self, panel_num):
        self.panel_num = panel_num
        # Define the camber line in (x, y) point sets, based on number of panels wanted and
        m = 0.25025
        k = 15.957
        x_i = np.linspace(0, 1, 100)       # Create array of x values to interpolate
        y_i = []                           # Create array of y values to interpolate
        for x in x_i:                      # Calculate y values for interpolation, save to list
            y = 0
            if 0 < x < m:
                y = (k/6) * (x**3 - 3*m*x**2 + m**2*(3-m)*x)
            elif m < x < 1:
                y = (k*m**3)/6 * (1-x)
            y_i.append(y)

        # Create interpolation function and x-y pairs for plotting
        z = scipy.interpolate.CubicSpline(x_i, y_i)
        x = np.linspace(0, 1, 1000)
        y = z(x)

        # Discretize points along the curve
        radius = (x_i.max() - x_i.min()) / 2        # Get radius of discretization circle
        x_center = (x_i.max() + x_i.min()) / 2      # Get center of circle (between endpoints of camberline)
        x_circle = (x_center + radius * np.cos(np.linspace(np.pi, 0,  self.panel_num + 1))).tolist()    # X-coords of circle

        # Get y coordinates of the panel nodes, length of panel, location of control points and vortex
        for i in range(self.panel_num):
            x1 = x_circle[i]
            x2 = x_circle[i+1]
            y1 = float(z(x1))
            y2 = float(z(x2))
            node1 = (x1, y1)
            node2 = (x2, y2)
            length = sqrt((x2 - x1)**2 + (y2 - y1)**2)

            # Get location of control points and vortex locations along panel
            v = np.array([x2-x1, y2-y1])
            u = v/length
            vortex_point = np.array(node1) + 0.25*length*u
            control_point = np.array(node1) + 0.75*length*u

            # Write data to dictionary
            self.master_panels[i] = {'n1': node1,
                                     'n2': node2,
                                     'l': length,
                                     'c_p': control_point.tolist(),
                                     'v_p': vortex_point.tolist()
                                     }

        # Plot the points of the discretized camberline and control and vortex locations
        cp_plot_x, cp_plot_y = [], []
        vp_plot_x, vp_plot_y = [], []
        plot_x1, plot_y1 = [], []
        plot_x2, plot_y2 = [], []
        for panel_num in self.master_panels.keys():
            panel = self.master_panels[panel_num]
            node1 = panel['n1']
            node2 = panel['n2']
            plot_x1.append(node1[0])
            plot_y1.append(node1[1])
            plot_x2.append(node2[0])
            plot_y2.append(node2[1])

            c_p = panel['c_p']
            cp_plot_x.append(c_p[0])
            cp_plot_y.append(c_p[1])
            v_p = panel['v_p']
            vp_plot_x.append(v_p[0])
            vp_plot_y.append(v_p[1])

        camber_plot = plt.figure(figsize=(12, 6))
        camber_plot.subplots_adjust(hspace=.5)
        cp = camber_plot.add_subplot(1, 1, 1)
        plt.xlim(-.25, 1.25)
        plt.ylim(-.25, .25)
        plt.gca().set_aspect('equal', adjustable='box')
        cp.set_title(f'Panels, Control Points, and Vortex Locations - {self.panel_num} Panels')
        cp.set_xlabel('x/c')
        cp.set_ylabel('y/c')
        cp.grid(linewidth=0.5, linestyle='--', color='grey')
        cp.plot(x, y, 'b', linewidth=1, label='camberline')                         # Camberline
        cp.plot(plot_x1, plot_y1, color='k', label='panels', linewidth=.75)         # Panels
        cp.plot(plot_x2, plot_y2, color='k', linewidth=.75)                         # Last panel
        cp.scatter(cp_plot_x, cp_plot_y, color='g', marker='x', s=50, label='control points')    # Control point
        cp.scatter(vp_plot_x, vp_plot_y, color='y', marker='+', s=50, label='vortex locations')  # Vortex location
        cp.scatter(plot_x1, plot_y1, color='r', marker='o', s=25)       # Node 1
        cp.scatter(plot_x2, plot_y2, color='r', marker='o', s=25)       # Node 2
        cp.legend(loc='upper left', fontsize=12)
        camber_plot.savefig(os.path.join(os.getcwd(), f'plots\\P2_{self.panel_num}_panels'))
        plt.draw()

        # Run panel solver
        vortexPanels.solvePanele(self)


if __name__ == '__main__':
    # Initialize class
    panel = vortexPanels()

    # Run Problem1
    panel.problemOne()

    # Run Problem2
    for i in [10, 20, 30, 40]:
        num_panels = i
        panel.problemTwo(num_panels)
    plt.show()
