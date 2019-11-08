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
- Predict the lift and quarter chord pitching moment characteristics, as well as the zero lift aoa, for a NACA 23012
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
        self.alpha_zl = 0                       # Zero lift angle of attack (degrees)
        self.coeffs = {}                        # Cl, Cmc4, and Cmle for airfoil per alpha and panel density
        self.chord_length = params['chord']     # Chord length of airfoil (m)
        self.camber_plot = []                   # Sets of x and y to plot the camber line
        self.problem = params['problem']        # Sets name of problem
        self.plot_colors = ['r', 'b', 'y', 'g', 'm', 'c', 'orange']

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
                for q in range(1, self.panel_num+1):
                    x_vq = panel_dict[q]['v'][0]
                    y_vq = panel_dict[q]['v'][1]
                    theta_p = panel_dict[q]['theta_p']
                    v_inf_n_p = self.v_inf * sin(self.alpha - theta_p)
                    for p in range(1, self.panel_num+1):
                        x_cp = panel_dict[p]['c'][0]
                        y_cp = panel_dict[p]['c'][1]
                        R = np.sqrt((x_cp - x_vq)**2 + (y_cp - y_vq)**2)
                        delta_2 = acos((x_cp - x_vq)/R)
                        delta_3 = delta_2 - theta_p
                        A[p-1][q-1] = cos(delta_3) / (2 * pi * R)
                    B[q-1] = v_inf_n_p
                    self.v_inf_n[panel_num][alpha]['v_inf_n_p'] = v_inf_n_p
                G = [i for i in np.linalg.inv(A).dot(B).T.tolist()[0]]
                total_gamma = sum(G)
                self.gamma[panel_num][alpha] = {'gammas': G, 'total_gamma': total_gamma}

    # Calculate lift and moment coefficients of the airfoil given gamma dictionary and airfoil properties
    def calcCoefficients(self):
        # Calc Cl and Cmc4 for a theoretical flat plate at angle of attacks
        self.coeffs['theory'] = {}
        for alpha in self.alpha_list:
            c_l_t = 2 * pi * np.deg2rad(alpha)
            c_mc4_t = 0
            self.coeffs['theory'][alpha] = {'C_l': c_l_t, 'C_mc4': c_mc4_t}
        # Calc Cl and Cmc4 for panel densities at angle of attacks
        for panel_num in self.panel_num_list:
            panel_dict = self.master_panels[panel_num]
            self.coeffs[panel_num] = {}
            for alpha in self.alpha_list:
                self.alpha = np.deg2rad(alpha)      # aoa in radians
                # Calc lift coefficient
                total_gamma = self.gamma[panel_num][alpha]['total_gamma']
                c_l = (2 * total_gamma) / (self.v_inf * self.chord_length)
                # Calc moment coefficient about the leading edge
                gammas = self.gamma[panel_num][alpha]['gammas']
                c_mle = 0
                for i in range(1, len(gammas) + 1):
                    x_v_p = panel_dict[i]['v'][0]
                    c_mle += (-2 * cos(self.alpha) * gammas[i-1] * x_v_p) / (self.v_inf * self.chord_length**2)
                # Calc moment coefficient about the quarter chord location
                c_mc4 = .25 * c_l + c_mle
                # Save coefficients to a dictionary
                self.coeffs[panel_num][alpha] = {'C_l': c_l, 'C_mc4': c_mc4}
        # If problem 2, print the coefficient values
        if self.problem == 'P2':
            print('Problem 2 Coefficients:\n')
            for panel_num in self.panel_num_list:
                alpha = 10
                print(f'{panel_num} panels at {alpha} degrees:\n' 
                      f"C_l = {round(self.coeffs[panel_num][alpha]['C_l'], 5)}\n" 
                      f"C_mc4 = {round(self.coeffs[panel_num][alpha]['C_mc4'], 5)}\n")

    # Take coefficient data and find the zero lift angle of attack
    def findZeroLiftAOA(self):
        # Use the highest panel density
        self.panel_num = self.panel_num_list[-1]
        # Build arrays to interpolate the c_l vs alpha curve
        alpha_i = []
        c_l_i = []
        for alpha in self.alpha_list:
            alpha_i.append(alpha)
            c_l_i.append(self.coeffs[self.panel_num][alpha]['C_l'])
        # Create interpolation function
        z = scipy.interpolate.CubicSpline(c_l_i, alpha_i)
        # Find interpolated angle when c_l = 0
        self.alpha_zl = round(z(0).tolist(), 5)
        print(f'For {self.problem}, the zero lift angle of attack = {self.alpha_zl} degrees')

    # Plot Coefficients (theoretical flat plate and calculated)
    def plotCoefficients(self):
        coeff_plot = plt.figure(figsize=(8, 8))
        coeff_plot.subplots_adjust(hspace=.25)
        coeff_plot.suptitle(f'{self.problem} - Aerodynamic Coefficient vs. Angle of Attack for Different Panel Densities')
        cl = coeff_plot.add_subplot(2, 1, 1)
        cl.set_ylabel('Cl', fontdict={'fontsize': 13})
        cl.grid(linewidth=0.5, linestyle='--', color='grey')
        cmc4 = coeff_plot.add_subplot(2, 1, 2)
        cmc4.set_ylabel('Cm_c/4', fontdict={'fontsize': 13})
        cmc4.set_xlabel('Angle of Attack [degrees]', fontdict={'fontsize': 13})
        cmc4.grid(linewidth=0.5, linestyle='--', color='grey')

        # Plot theoretical coefficients
        c_l_t, c_mc4_t = [], []
        for alpha in self.alpha_list:
            c_l_t.append(self.coeffs['theory'][alpha]['C_l'])
            c_mc4_t.append(self.coeffs['theory'][alpha]['C_mc4'])
        cl.plot(self.alpha_list, c_l_t, color='k', label='Theoretical Value')
        cmc4.plot(self.alpha_list, c_mc4_t, color='k', label='Flat Plate')
        # Plot calculated coefficients for each panel density
        for panel_num in self.panel_num_list:
            c_l, c_mc4= [], []
            for alpha in self.alpha_list:
                c_l.append(self.coeffs[panel_num][alpha]['C_l'])
                c_mc4.append(self.coeffs[panel_num][alpha]['C_mc4'])
            color = self.plot_colors[self.panel_num_list.index(panel_num)]
            cl.plot(self.alpha_list, c_l, color=color, label=f'{panel_num} panels')
            cmc4.plot(self.alpha_list, c_mc4, color=color, label=f'{panel_num} panels')
        cl.legend(loc='upper left', fontsize=12)
        cmc4.legend(loc='upper left', fontsize=12)
        # Save plot
        coeff_plot.savefig(os.path.join(os.getcwd(), f'plots\\{self.problem}_coeffs'))
        plt.draw()

    # Plot the calculated gamma distributions
    def plotGamma(self):
        alpha = self.alpha_list[-1]
        gamma_plot = plt.figure(figsize=(8, 8))
        gamma_plot.subplots_adjust(hspace=.25)
        gam = gamma_plot.add_subplot(1, 1, 1)
        gam.set_title(f'{self.problem} - Gamma Distribution on Airfoil for Different Panel Densities, $\\alpha$ = {alpha} degrees')
        gam.set_ylabel('$\gamma$ [$\\frac{m^2}{s}$]', fontdict={'fontsize': 13})
        gam.set_xlabel('X Location on Airfoil [m]', fontdict={'fontsize': 13})
        gam.grid(linewidth=0.5, linestyle='--', color='grey')
        # Plot gamma for last alpha in alpha_list
        for panel_num in self.panel_num_list:
            x = []
            for i in range(1, panel_num + 1):
                x.append(self.master_panels[panel_num][i]['v'][0])
            gammas = self.gamma[panel_num][alpha]['gammas']
            color = self.plot_colors[self.panel_num_list.index(panel_num)]
            gam.plot(x, gammas, color=color, label=f'{panel_num} panels')
        gam.legend(loc='upper right', fontsize=12)
        gamma_plot.savefig(os.path.join(os.getcwd(), f'plots\\{self.problem}_gammadist'))
        plt.draw()

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
            cp.grid(linewidth=0.5, linestyle='--', color='grey')  # Gridlines
            cp.plot(self.camber_plot[0], self.camber_plot[1], 'b', linewidth=1, label='camberline')  # Camberline
            cp.plot(plot_x1, plot_y1, color='k', label='panels', linewidth=.75)  # Panels
            cp.plot(plot_x2, plot_y2, color='k', linewidth=.75)  # Last panel
            cp.scatter(cp_plot_x, cp_plot_y, color='g', marker='x', s=50, label='control points')  # Control point
            cp.scatter(vp_plot_x, vp_plot_y, color='y', marker='+', s=50,
                       label='vortex locations')  # Vortex location
            cp.scatter(plot_x1, plot_y1, color='r', marker='o', s=25)  # Node 1
            cp.scatter(plot_x2, plot_y2, color='r', marker='o', s=25)  # Node 2
            cp.legend(loc='upper left', fontsize=12)
            camber_plot.savefig(os.path.join(os.getcwd(), f'plots\\{self.problem}_{self.panel_num}_panels'))
            plt.draw()

    # Plot the airfoil in and streamlines around the airfoil
    def plotStreamlines(self, alpha, panel_num):
        # Convert alpha from deg to rad
        alpha_rad = np.deg2rad(alpha)

        # Create a mesh grid
        w = 3 * self.chord_length
        density = 101
        densityj = 101j
        x_r = np.linspace(-w, w, density)
        y_r = np.linspace(-w, w, density)
        X, Y = np.meshgrid(x_r, y_r)
        Y1, X1 = np.mgrid[-w:w:densityj, -w:w:densityj]
        U = cos(alpha_rad) * self.v_inf * np.ones([len(x_r), len(x_r)])
        V = sin(alpha_rad) * self.v_inf * np.ones([len(y_r), len(y_r)])

        # Create interpolation function for the velocity of the airfoil in x direction
        x_v, y_v = [], []
        x, y, = [], []
        theta, v_n = [], []
        x_min = 0
        x_max = self.chord_length
        y_min = 0
        y_max = 0   # Initialize variable, rewrite with actual value below
        for i in range(1, panel_num + 1):
            x_v_p = self.master_panels[panel_num][i]['v'][0]
            y_v_p = self.master_panels[panel_num][i]['v'][1]
            if y_v_p > y_max:
                y_max = y_v_p
            theta.append(self.master_panels[panel_num][i]['theta_p'] + np.pi)
            v_n.append(self.v_inf_n[panel_num][alpha]['v_inf_n_p'])
            x.append(x_v_p)
            y.append(y_v_p)
        vel_x = scipy.interpolate.CubicSpline(x, v_n)
        theta_x = scipy.interpolate.CubicSpline(x, theta)
        y_x = scipy.interpolate.CubicSpline(x, y)

        # Create lists for y interpolation
        y1, y2 = [], []
        theta1, theta2 = [], []
        v_n1, v_n2 = [], []
        for i in range(panel_num):
            y_o = y[i]
            theta_o = theta[i]
            v_n_o = v_n[0]
            if y_o <= y_max:
                y1.append(y_o)
                theta1.append(theta_o)
                v_n1.append(v_n_o)
            else:
                y2.append(y_o)
                theta2.append(theta_o)
                v_n2.append(v_n_o)

        vel_y1 = scipy.interpolate.CubicSpline(y1, v_n1)
        theta_y1 = scipy.interpolate.CubicSpline(y1, theta1)
        v_n_y1 = scipy.interpolate.CubicSpline(y1, v_n1)
        vel_y2 = scipy.interpolate.CubicSpline(y2, v_n2)
        theta_y2 = scipy.interpolate.CubicSpline(y2, theta2)
        v_n_y2 = scipy.interpolate.CubicSpline(y2, v_n2)

        # Iterate through the meshgrid and add the velocity components to U
        x_list = X1[0].tolist()
        x_index = 0
        for x_m in x_list:
            # Check if x is in x_min and x_max range
            if x_min <= x_m and x_m <= x_max:
                y_i = y_x(x_m)
                theta_i = theta_x(x_m)
                vel_i = vel_x(x_m)
            x_index += 1

        # Iterate through the meshgrid and add the velocity components to U
        y_list = Y1[:, 0].tolist()
        y_index = 0
        for y_m in y_list:
            if y_min <= y_m and y_m <= y_max:

                y_i = y_x(x_m)
                theta_i = theta_x(x_m)
                vel_i = vel_x(x_m)










        x_index, y_index = 0, 0
        print(y_list)
        # Iterate through the meshgrid and add the velocity components to U and V
        for x_m in x_list:
            # Check if x is in x_min and x_max range
            if x_min <= x_m and x_m <= x_max:
                for y_m in y_list:
                    # Check if value is in y_min and y_max range
                    if y_min <= y_m and y_m <= y_max:
                        U[x_index, y_index] = U[x_index, y_index] + zx(x_m)  # Adds interpolated velocity to U
                        V[x_index, y_index] = V[x_index, y_index] + zy(y_m)  # Adds interpolated velocity to V
            x_index += 1
            y_index += 1





        #print(X1, Y1)



        stream_plot = plt.figure(figsize=(12, 6))
        stream_plot.subplots_adjust(hspace=.5, left=.07, right=.97, top=.95, bottom=.05)
        stream_plot.gca().set_aspect('equal', adjustable='box')
        sp = stream_plot.add_subplot(1, 1, 1)
        sp.set_title(f'{self.problem} - Airfoil in Streamlines at AOA = {np.rad2deg(alpha)} degrees')
        sp.set_xlabel('X Location [m]')
        sp.set_ylabel('Y Location [m]')
        sp.grid(linewidth=.5, color='grey', linestyle='--')
        sp.streamplot(X1, Y1, U, V, density=.75, arrowstyle='->')
        #sp.scatter(X, Y, s=.5, color='k')
        plt.draw()

    # Run problem 1
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
            for i in range(1, self.panel_num + 1):
                x1 = x[i-1]
                x2 = x[i]
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
        # Find the zero lift angle of attack
        vortexPanels.findZeroLiftAOA(self)
        # Plot gamma distribution
        vortexPanels.plotGamma(self)

    # Run problem 2 and 3
    def problemTwoThree(self):
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
            # Get y coordinates of the panel nodes, length of panel, location of control points and vortex
            self.master_panels[self.panel_num] = {}
            for i in range(1, self.panel_num + 1):
                x1 = x_circle[i-1]
                x2 = x_circle[i]
                y1 = float(z(x1))
                y2 = float(z(x2))
                node1 = (x1, y1)
                node2 = (x2, y2)
                length = sqrt((x2 - x1)**2 + (y2 - y1)**2)
                theta_p = acos((x2 - x1) / length)      # in radians
                if y2 - y1 <= 0:
                    theta_p = -1 * theta_p
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
                                                         }
        # Run panel solver for all panel numbers
        vortexPanels.solvePanels(self)
        # Plot the camberline for all panel numbers
        #vortexPanels.plotCamberline(self)
        # Calculate the aerodynamic coefficients
        vortexPanels.calcCoefficients(self)
        # Plot aerodynamic coefficients wrt angle of attack (if applicable)
        if not len(self.alpha_list) == 1:
            pass
            #vortexPanels.plotCoefficients(self)
        # Find the zero lift angle of attack
        vortexPanels.findZeroLiftAOA(self)
        # Plot gamma distribution
        #vortexPanels.plotGamma(self)
        # Plot the airfoil in streamlines (problem 3)
        vortexPanels.plotStreamlines(self, alpha=10, panel_num=self.panel_num_list[-1])



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

    run1 = False
    run23 = True

    # Run Problem1
    if run1:
        params = {'v': 1,
                  'chord': 1,
                  'aoa': np.arange(-10, 11, step=1).tolist(),
                  'panels': [10, 40, 60, 80],
                  'problem': 'P1'}
        panel = vortexPanels(params)
        panel.problemOne()

    # Run Problem2 and Problem3
    if run23:
        params = {'v': 100,
                  'chord': 3,
                  'aoa': np.arange(-10, 11, step=1).tolist(),
                  'panels': [80],
                  'problem': 'P2'}
        panel = vortexPanels(params)
        panel.problemTwoThree()

    # Show all of the plots
    plt.show()
