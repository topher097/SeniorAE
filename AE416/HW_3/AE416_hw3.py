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
import scipy.interpolate



class vortexPanels:

    # Initialize variables
    def __init__(self):
        self.master_panels = {}        # Dict of panel and their node coordinates, length, vortex location,
                                                # and control point location
        self.camber_line_points = []        # Define the camber line points in (x, y) sets
        self.panel_num = 40                 # Number of panels in camberline
        self.max_length = .05               # Set max panel length (by percentage of chord length)
        self.min_length = .01               # Ser min panel length (by percentage of chord length)

        self.v_inf = 0                      # Freestream velocity scalar (m/s)
        self.alpha = 0                      # Angle of attack (degrees)
        self.chord_length = 1               # Chord length of airfoil (m)
        self.camber_arclength = 0           # Arc length of camberline [m]

    # Use camber line points and number of panels to create panels, store node points and panel number in dict
    def createPanels(self):
        pass

    # Solve the lumped vortex method given master coord dict, v_inf, and alpha
    def solvePanele(self):
        pass

    # Compute problem 1
    def problemOne(self):
        # Define the camber line in (x, y) point sets

        x = np.linspace(0, 1, self.panel)
        self.camber_line_points = []

        # Create panels
        vortexPanels.createPanels(self)
        # Run panel solver
        vortexPanels.solvePanele(self)

    # Compute problem 2
    def problemTwo(self):
        # Define the camber line in (x, y) point sets
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

        # Create interpolation function
        z = scipy.interpolate.CubicSpline(x_i, y_i)

        # Compute the length of the camberline by calculating the length between many nodes along camberline
        x_r = np.linspace(0, 1, 1000)
        for i in range(0, len(x_r)-1):
            x1 = x_r[i]
            x2 = x_r[i+1]
            y1 = z(x1)
            y2 = z(x2)
            self.camber_arclength += np.sqrt((x2 - x1)**2 + (y2 - y1)**2)

        # Compute the
        self.camber_line_points = []

        # Create panels
        vortexPanels.createPanels(self)
        # Run panel solver
        vortexPanels.solvePanele(self)


if __name__ == '__main__':
    # Initialize class
    panel = vortexPanels()

    # Run Problems
    panel.problemOne()
    panel.problemTwo()
