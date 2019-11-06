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
from math import sqrt, acos, cos, sin, pi
import matplotlib.pyplot as plt
import os
import shutil
import msgpack
import scipy.interpolate
from sympy import Symbol, Matrix


class vortexPanels():

    # Initialize variables
    def __init__(self, params):
        self.master_panels = {}                 # Dict of panel and their node coordinates, length, vortex location,
                                                # control point location, slope, and beta
        self.gamma = {}                         # Dict of gamma for each angle of attack
        self.panel_num_list = params['panels']  # Number of panels in camberline
        self.panel_num = 0                      # Initialize panel number variable
        self.v_inf = params['v']                # Freestream velocity scalar (m/s)
        self.v_inf_n = {}                       # Normal velocity of airfoil (m/s)
        self.alpha_list = params['aoa']         # Angle of attack in list (degrees)
        self.alpha = 0                          # Angle of attack (rad)
        self.coeffs = {}                        # Cl, Cmc4, and Cmle for airfoil per alpha and panel density
        self.chord_length = params['chord']     # Chord length of airfoil (m)
        self.camber_plot = []                   # Sets of x and y to plot the camber line
        self.problem = params['problem']        # Sets name of problem

    # Solve the lumped vortex method to get the gammas for each panel and total gamma on airfoil
    def solvePanels(self):
        for panel_num in self.panel_num_list:
            self.panel_num = panel_num
            self.gamma[panel_num] = {}
            self.v_inf_n[panel_num] = {}
            for alpha in self.alpha_list:
                self.v_inf_n[panel_num][alpha] = {}
                panel_dict = self.master_panels[self.panel_num]
                self.alpha = np.deg2rad(alpha)
                # Initialize matrices
                A = np.empty((self.panel_num, self.panel_num))
                B = np.empty((self.panel_num, 1))
                for q in range(0, self.panel_num):
                    x_vq = panel_dict[q]['v'][0]
                    y_vq = panel_dict[q]['v'][1]
                    theta_p = panel_dict[q]['theta_p']
                    v_inf_n_p = self.v_inf * sin(self.alpha - theta_p)
                    for p in range(0, self.panel_num):
                        x_cp = panel_dict[p]['c'][0]
                        y_cp = panel_dict[p]['c'][1]
                        R = np.sqrt((x_cp - x_vq)**2 + (y_cp - y_vq)**2)
                        delta_2 = acos((x_cp - x_vq)/R)
                        delta_3 = delta_2 - theta_p

                        A[p-1][q-1] = cos(delta_3) / (2 * pi * R)
                    B[q-1] = v_inf_n_p
                    self.v_inf_n[panel_num][alpha]['v_inf_n_p'] = v_inf_n_p

                G = np.linalg.inv(A).dot(B)
                total_gamma = np.sum(G, 0)
                self.gamma[panel_num][alpha] = {'gammas': G, 'total_gamma': total_gamma[0]}
            # Save gamma dict to msgpack file if problem 2
            if self.problem == 'P2':
                vortexPanels.saveDict(self, self.gamma, f'gamma_{self.panel_num}panels')

    # Calculate lift and moment coefficients of the airfoil given gamma dictionary and airfoil properties
    def calcCoefficients(self):
        # L'_p = rho * v_inf * gamma_p
        for panel_num in self.panel_num_list:
            panel_dict = self.master_panels[panel_num]
            self.coeffs[panel_num] = {}
            for alpha in self.alpha_list:
                self.alpha = np.deg2rad(alpha)      # aoa in radians
                # Calc lift coefficient
                total_gamma = self.gamma[panel_num][alpha]['total_gamma']
                c_l = (2 * total_gamma) / (self.v_inf * self.chord_length)
                # Calc moment coefficient about the leading edge
                gammas = self.gamma[panel_num][alpha]['gammas'].T.tolist()[0]
                c_mle = 0
                for i in range(1, len(gammas) + 1):
                    x_v_p = panel_dict[i-1]['v'][0]
                    c_mle += (-2 * cos(self.alpha) * gammas[i-1] * x_v_p) / (self.v_inf * self.chord_length**2)
                # Calc moment coefficient about the quarter chord location
                c_mc4 = .25 * c_l + c_mle
                # Save coefficients to a dictionary
                self.coeffs[panel_num][alpha] = {'C_l': c_l, 'C_mc4': c_mc4}

    # Plot Coefficients
    def plotCoefficients(self):
        coeff_plot = plt.figure(figsize=(8, 8))
        coeff_plot.subplots_adjust(hspace=.25)
        coeff_plot.suptitle('Aerodynamic Coefficient vs. Angle of Attack for Different Panel Densities')
        cl = coeff_plot.add_subplot(2, 1, 1)
        cl.set_ylabel('Cl')
        cl.grid(linewidth=0.5, linestyle='--', color='grey')
        cmc4 = coeff_plot.add_subplot(2, 1, 2)
        cmc4.set_ylabel('Cm_c/4')
        cmc4.set_xlabel('Angle of Attack [degrees]')
        cmc4.grid(linewidth=0.5, linestyle='--', color='grey')

        # Calc theoretical values for flat plate
        c_l_t, c_mc4_t = [], []
        for alpha in self.alpha_list:
            c_l_t.append(2 * pi * np.deg2rad(alpha))
            c_mc4_t.append(0)
        cl.plot(self.alpha_list, c_l_t, color='k', label='Theoretical Value')
        cmc4.plot(self.alpha_list, c_mc4_t, color='k', label='Theoretical Value')
        # Get coeff to plot
        for panel_num in self.panel_num_list:
            c_l, c_mc4= [], []
            for alpha in self.alpha_list:
                c_l.append(self.coeffs[panel_num][alpha]['C_l'])
                c_mc4.append(self.coeffs[panel_num][alpha]['C_mc4'])
            alpha_color = np.random.rand(3,)
            cl.plot(self.alpha_list, c_l, color=alpha_color, label=f'{panel_num} panels')
            cmc4.plot(self.alpha_list, c_mc4, color=alpha_color, label=f'{panel_num} panels')

        cl.legend(loc='upper right', fontsize=12)
        cmc4.legend(loc='upper right', fontsize=12)
        plt.draw()

    # Compute problem 1
    def problemOne(self):
        # Write master dict for all panel numbers
        for panel_num in self.panel_num_list:
            self.panel_num = panel_num
            # Define the camber line in (x, y) point sets
            x = np.linspace(0, self.chord_length, self.panel_num + 1)
            y = np.zeros(len(x))

            # Save the camber plot points
            self.camber_plot = [x, y]

            # Get y coordinates of the panel nodes, length of panel, location of control points and vortex
            self.master_panels[self.panel_num] = {}
            for i in range(self.panel_num):
                x1 = x[i]
                x2 = x[i + 1]
                y1 = 0
                y2 = 0
                node1 = (x1, y1)
                node2 = (x2, y2)
                length = sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
                theta_p = 0

                # Get location of control points and vortex locations along panel
                v = np.array([x2 - x1, y2 - y1])
                u = v / length
                vortex_point = np.array(node1) + 0.25 * length * u
                control_point = np.array(node1) + 0.75 * length * u

                # Write data to dictionary
                self.master_panels[self.panel_num][i] = {'n1': node1,
                                                         'n2': node2,
                                                         'l': length,
                                                         'c': control_point.tolist(),
                                                         'v': vortex_point.tolist(),
                                                         'theta_p': theta_p,
                                                         }
        # Run panel solver for all panel numbers and angle of attacks
        vortexPanels.solvePanels(self)
        # Plot the camberline for all panel numbers at first angle of attack
        #vortexPanels.plotCamberline(self)
        # Calculate the aerodynamic coefficients
        vortexPanels.calcCoefficients(self)
        # Plot the aerodynamic coefficients
        vortexPanels.plotCoefficients(self)

    # Compute problem 2
    def problemTwo(self):
        # Write master dict for all panel numbers
        for panel_num in self.panel_num_list:
            self.panel_num = panel_num
            # Define the camber line in (x, y) point sets, based on number of panels wanted and
            m = 0.25025
            k = 15.957
            x_i = np.linspace(0, 1, 100)        # Create array of x values to interpolate
            y_i = []                            # Create array of y values to interpolate
            for x in x_i:                       # Calculate y values for interpolation, save to list
                y = 0
                if 0 < x < m:
                    y = (k/6) * (x**3 - 3*m*x**2 + m**2*(3-m)*x)
                elif m < x < 1:
                    y = (k*m**3)/6 * (1-x)
                y_i.append(y)

            x_i = [i * self.chord_length for i in x_i]
            y_i = [i * self.chord_length for i in y_i]

            # Create interpolation function and x-y pairs for plotting
            z = scipy.interpolate.CubicSpline(x_i, y_i)
            x = np.linspace(0, 1 * self.chord_length, 1000)
            y = z(x)
            self.camber_plot = (x, y)

            # Discretize points along the curve
            radius = x_i[0] - x_i[-1]            # Get radius of discretization circle
            x_center = x_i[-1]                   # Get center of circle (last node)
            x_circle = (x_center+radius*np.cos(np.linspace(0, np.pi/2, self.panel_num + 1))).tolist()  # X-coords of circle
            #x_circle = [self.chord_length/2 * (1 - np.cos(i)) for i in np.linspace(0, np.pi, self.panel_num + 1)]

            # Get y coordinates of the panel nodes, length of panel, location of control points and vortex
            self.master_panels[self.panel_num] = {}
            for i in range(self.panel_num):
                x1 = x_circle[i]
                x2 = x_circle[i+1]
                y1 = float(z(x1))
                y2 = float(z(x2))
                node1 = (x1, y1)
                node2 = (x2, y2)
                length = sqrt((x2 - x1)**2 + (y2 - y1)**2)
                theta_p = acos((x2 - x1) / (y2 - y1))
                # Calculate Beta value (rad) for the panel
                if x2 - x1 <= 0:
                    beta = acos((y2 - y1) / length)
                else:
                    beta = np.pi + acos(-(y2 - y1) / length)

                # Get location of control points and vortex locations along panel
                v = np.array([x2-x1, y2-y1])
                u = v/length
                vortex_point = np.array(node1) + 0.25*length*u
                control_point = np.array(node1) + 0.75*length*u

                # Write data to dictionary
                self.master_panels[self.panel_num][i] = {'n1': node1,
                                                         'n2': node2,
                                                         'l': length,
                                                         'c': control_point.tolist(),
                                                         'v': vortex_point.tolist(),
                                                         'theta_p': theta_p,
                                                         'beta': beta
                                                         }

        # Run panel solver for all panel numbers
        vortexPanels.solvePanels(self)
        # Plot the camberline for all panel numbers
        vortexPanels.plotCamberline(self)
        # Save the master panel dict to a msgpack file to be used in problem 3
        vortexPanels.saveDict(self, self.master_panels, 'master')

    # Compute problem 3
    def problemThree(self):
        # Load the master panel dict from the second problem
        self.master_panels = vortexPanels.loadDict(self, 'master')

        # Load the gamma dict from second problem
        self.gamma = vortexPanels.loadDict(self, 'gamma')

        # Generate the linear system to solve for gamma for each panel
        # Sum all gamma contributions
        # Calculate the Cm_c4 and Cm_le of the airfoil

    # Save dictionary to a message pack file
    def saveDict(self, data, name):
        with open(f'{name}_dict.msgpack', 'wb') as outfile:
            msgpack.pack(data, outfile)

    # Load dictionary from a message pack file
    def loadDict(self, name):
        with open(f'{name}_dict.msgpack', 'rb') as infile:
            data = msgpack.unpack(infile)
        return data

    # Plot the points of the discretized camberline and control point and vortex locations
    def plotCamberline(self):
        for panel_num in self.panel_num_list:
            self.panel_num = panel_num
            cp_plot_x, cp_plot_y = [], []
            vp_plot_x, vp_plot_y = [], []
            plot_x1, plot_y1 = [], []
            plot_x2, plot_y2 = [], []
            for panel in self.master_panels[self.panel_num].keys():
                panel_info = self.master_panels[self.panel_num][panel]
                node1 = panel_info['n1']
                node2 = panel_info['n2']
                plot_x1.append(node1[0])
                plot_y1.append(node1[1])
                plot_x2.append(node2[0])
                plot_y2.append(node2[1])

                c_p = panel_info['c']
                cp_plot_x.append(c_p[0])
                cp_plot_y.append(c_p[1])
                v_p = panel_info['v']
                vp_plot_x.append(v_p[0])
                vp_plot_y.append(v_p[1])

            camber_plot = plt.figure(figsize=(12, 6))
            camber_plot.subplots_adjust(hspace=.5, left=.07, right=.97, top=.95, bottom=.05)
            cp = camber_plot.add_subplot(1, 1, 1)
            plt.xlim(-.25, .25 + self.chord_length)
            plt.ylim(-.25 * self.chord_length, .25 * self.chord_length)
            plt.gca().set_aspect('equal', adjustable='box')
            cp.set_title(f'Panels, Control Points, and Vortex Locations - {self.panel_num} Panels')
            cp.set_xlabel('x/c')
            cp.set_ylabel('y/c')
            cp.grid(linewidth=0.5, linestyle='--', color='grey')                        # Gridlines
            cp.plot(self.camber_plot[0], self.camber_plot[1], 'b', linewidth=1, label='camberline')  # Camberline
            cp.plot(plot_x1, plot_y1, color='k', label='panels', linewidth=.75)         # Panels
            cp.plot(plot_x2, plot_y2, color='k', linewidth=.75)                         # Last panel
            cp.scatter(cp_plot_x, cp_plot_y, color='g', marker='x', s=50, label='control points')    # Control point
            cp.scatter(vp_plot_x, vp_plot_y, color='y', marker='+', s=50, label='vortex locations')  # Vortex location
            cp.scatter(plot_x1, plot_y1, color='r', marker='o', s=25)                   # Node 1
            cp.scatter(plot_x2, plot_y2, color='r', marker='o', s=25)                   # Node 2
            cp.legend(loc='upper left', fontsize=12)
            camber_plot.savefig(os.path.join(os.getcwd(), f'plots\\{self.problem}_{self.panel_num}_panels'))
            plt.draw()


if __name__ == '__main__':
    # Initialize plot folder
    try:
        shutil.rmtree(os.path.join(os.getcwd(), 'plots\\'))
    except Exception as e:
        print(f'Could not remove plot folder, error: {str(e)}')
    try:
        os.mkdir(os.path.join(os.getcwd(), 'plots\\'))
    except Exception as e:
        print(f'Could not create plot folder, error: {str(e)}')

    # Run Problem1
    params = {'v': 10,
              'chord': 3,
              'aoa': np.arange(-10, 11, step=1).tolist(),
              'panels': [20, 40, 60, 80],
              'problem': 'P1'}
    panel = vortexPanels(params)
    panel.problemOne()

    '''
    # Run Problem2
    params = {'v': 100,
              'chord': 3,
              'aoa': [10],
              'panels': [20],
              'problem': 'P2'}
    panel = vortexPanels(params)
    panel.problemTwo()

    # Run Problem2
    params = {'v': 100,
              'chord': 3,
              'aoa': [10],
              'panels': [20],
              'problem': 'P3'}
    panel = vortexPanels(params)
    panel.problemThree()
    '''
    plt.show()
