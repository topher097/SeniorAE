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
import scipy.interpolate


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
        text_st = ''
        if self.problem == 'P2':
            str1 = 'Problem 2 Coefficients:\n'
            text_st += str1
            for panel_num in self.panel_num_list:
                alpha = 10
                str2 = f'{panel_num} panels at {alpha} degrees:\n' \
                       f"C_l = {round(self.coeffs[panel_num][alpha]['C_l'], 5)}\n" \
                       f"C_mc4 = {round(self.coeffs[panel_num][alpha]['C_mc4'], 5)}\n"
                print(str2)
                text_st += str2
        # If problem 1, print to a csv the coeff vals and the percent error for analysis
        elif self.problem == 'P1':
            for panel_num in self.panel_num_list:
                for alpha in self.alpha_list:
                    c_l_actual = self.coeffs['theory'][alpha]['C_l']
                    c_m_actual = self.coeffs['theory'][alpha]['C_mc4']
                    c_l_text = f"{round(self.coeffs[panel_num][alpha]['C_l'], 5)}"
                    c_m_text = f"{round(self.coeffs[panel_num][alpha]['C_mc4'], 5)}"
                    c_l_error_text = f"{100*abs(c_l_actual - self.coeffs[panel_num][alpha]['C_l'])/c_l_actual}"
                    c_m_error_text = f"{100*abs(c_m_actual - self.coeffs[panel_num][alpha]['C_mc4'])/.0001}"
                    str2 = f"{panel_num}, {alpha}, {c_l_text}, {c_m_text}, {c_l_error_text}, {c_m_error_text}"
                    str3 = f'{panel_num} panels at {alpha} degrees:\n' \
                           f"C_l = {c_l_text}\n" \
                           f"C_mc4 = {c_m_text}\n"
                    print(str3)
                    text_st += str2
        with open(f'{self.problem}_Coeff_Summary.csv', 'wt') as txt:
            txt.write(text_st)

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
        cl = coeff_plot.add_subplot(2, 1, 1)
        cl.set_title(f'{self.problem} - Aerodynamic Coefficient vs. Angle of Attack for Different Panel Densities')
        #cl.set_title(f'{self.problem} - Aerodynamic Coefficient vs. Angle of Attack for 60 Panels')
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
        if 'P1' == self.problem:
            panel_num_list = [60]
        else:
            panel_num_list = self.panel_num_list
        for panel_num in panel_num_list:
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
        # Plot percent error of calc vs theoretical
        coeff_plot_e = plt.figure(figsize=(8, 8))
        coeff_plot_e.subplots_adjust(hspace=.25)
        cle = coeff_plot_e.add_subplot(2, 1, 1)
        cle.set_title(f'{self.problem} - Percent Error of Aerodynamic Coefficient vs. Angle of Attack\n'
                      f'With Respect to Theoretical Flat Plate Coefficients')
        cle.set_ylabel('Cl % Error', fontdict={'fontsize': 13})
        cle.grid(linewidth=0.5, linestyle='--', color='grey')
        cmc4e = coeff_plot_e.add_subplot(2, 1, 2)
        cmc4e.set_ylabel('Cm_c/4 % Error', fontdict={'fontsize': 13})
        cmc4e.set_xlabel('Angle of Attack [degrees]', fontdict={'fontsize': 13})
        cmc4e.grid(linewidth=0.5, linestyle='--', color='grey')
        for panel_num in self.panel_num_list:
            c_l, c_mc4 = [], []
            for alpha in self.alpha_list:
                cl = self.coeffs[panel_num][alpha]['C_l']
                cm = self.coeffs[panel_num][alpha]['C_mc4']
                clt = self.coeffs['theory'][alpha]['C_l']
                cmt = self.coeffs['theory'][alpha]['C_mc4']
                c_l.append(100 * abs((clt-cl)/(clt+.00000001)))
                c_mc4.append(100 * abs((cmt-cm)/(cmt+.00000001)))
            color = self.plot_colors[self.panel_num_list.index(panel_num)]
            cle.plot(self.alpha_list, c_l, color=color, label=f'{panel_num} panels')
            cmc4e.plot(self.alpha_list, c_mc4, color=color, label=f'{panel_num} panels')
        cle.legend(loc='upper left', fontsize=12)
        cmc4e.legend(loc='upper left', fontsize=12)
        # Save plot
        coeff_plot_e.savefig(os.path.join(os.getcwd(), f'plots\\{self.problem}_coeffs_error'))
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
        gammas = self.gamma[panel_num][alpha]['gammas']
        # Create a mesh grid
        w = 3 * self.chord_length
        densityj = 100j
        Y1, X1 = np.mgrid[-1:1:densityj, -w:self.chord_length + w:densityj]
        U = np.zeros([len(X1[0].tolist()), len(X1[0].tolist())])
        V = np.zeros([len(Y1[:, 0].tolist()), len(Y1[:, 0].tolist())])
        # Try and see if the data exists to save computing time, otherwise, redo calculations
        fileU = f'streams\\{self.problem}_U_{str(densityj)}_{panel_num}p_{alpha}a_{self.chord_length}c.npy'
        fileV = f'streams\\{self.problem}_V_{str(densityj)}_{panel_num}p_{alpha}a_{self.chord_length}c.npy'
        fileU_exist = os.path.exists(os.path.join(os.getcwd(), fileU))
        fileV_exist = os.path.exists(os.path.join(os.getcwd(), fileV))
        if fileU_exist and fileV_exist:
            U = np.load(os.path.join(os.getcwd(), fileU))
            V = np.load(os.path.join(os.getcwd(), fileV))
        else:
            # Iterate through the meshgrid and calculate the u and v components at each point in the meshgrid
            vinf_x = cos(alpha_rad) * self.v_inf
            vinf_y = sin(alpha_rad) * self.v_inf
            for i in range(len(X1[0].tolist())):
                for j in range(len(Y1[:, 0].tolist())):
                    # Calculate the induced velocity from each panel vortex
                    x_m = X1[i][j]
                    y_m = Y1[i][j]
                    v_ix, v_iy = 0, 0
                    for panel in range(panel_num):
                        x_v = self.master_panels[panel_num][panel+1]['v'][0]
                        y_v = self.master_panels[panel_num][panel+1]['v'][1]
                        gamma = gammas[panel]
                        dist = abs(sqrt((x_m - x_v)**2 + (y_m - y_v)**2))
                        vel = (gamma/(4*pi*dist**3)) * \
                              np.cross(np.array([[0], [0], [-1]]),
                              np.array([[(x_m-x_v)], [y_m-y_v], [0]]), axis=0)
                        v_ix += vel[0][0]
                        v_iy += vel[1][0]
                    # Add velocity from airfoil vortices and v_inf components to vector field
                    U[i][j] = vinf_x + v_ix
                    V[i][j] = vinf_y + v_iy
            # Save the vector field arrays so iterations can be done faster for higher density fields
            np.save(os.path.join(os.getcwd(), fileU), U, allow_pickle=True)
            np.save(os.path.join(os.getcwd(), fileV), V, allow_pickle=True)
        # Plot the streamline, save the plot
        plot_info_text = f'Chord length = {self.chord_length} [m]\n' \
                         f'Panel Number = {panel_num}\n' \
                         f'Streamline mesh density = {str(densityj).replace("j","")}\n' \
                         f'Angle of Attack = {alpha} [deg]'
        stream_plot = plt.figure(figsize=(12, 6))
        stream_plot.subplots_adjust(hspace=.5, left=.02, right=.99, top=.95, bottom=.1)
        stream_plot.gca().set_aspect('equal', adjustable='box')
        props = dict(boxstyle='round', facecolor='white', alpha=0.5)
        sp = stream_plot.add_subplot(1, 1, 1)
        sp.set_title(f'{self.problem} - Airfoil in Streamlines at AOA = {alpha} degrees')
        sp.set_xlabel('X Location [m]')
        sp.set_ylabel('Y Location [m]')
        sp.set_ylim(-2, 2)
        sp.plot(self.camber_plot[0], self.camber_plot[1], 'r', linewidth=3, label='camberline')
        sp.streamplot(X1, Y1, U, V, density=1.75, arrowstyle='-', linewidth=.5, zorder=10)
        sp.text(0.05, 0.95, plot_info_text, transform=sp.transAxes, fontsize=11, verticalalignment='top', bbox=props)
        stream_plot.savefig(os.path.join(os.getcwd(), f'plots\\{self.problem}_stream_{panel_num}_panels'))
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
        vortexPanels.plotCamberline(self)
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
            x_circle = (x_center+radius*np.cos(np.linspace(0, np.pi/2, self.panel_num + 1))).tolist()  # X-cord of circ
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
        vortexPanels.plotCamberline(self)
        # Calculate the aerodynamic coefficients
        vortexPanels.calcCoefficients(self)
        # Plot aerodynamic coefficients wrt angle of attack (if applicable)
        if len(self.alpha_list) >= 10:
            vortexPanels.plotCoefficients(self)
        # Find the zero lift angle of attack
        vortexPanels.findZeroLiftAOA(self)
        # Plot gamma distribution
        vortexPanels.plotGamma(self)
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

    run1 = True
    run23 = True

    # Run Problem1
    if run1:
        params = {'v': 1,
                  'chord': 1,
                  'aoa': np.arange(-10, 11, step=1).tolist(),
                  'panels': [20, 40, 60, 80],
                  'problem': 'P1'}
        panel = vortexPanels(params)
        panel.problemOne()

    # Run Problem2 and Problem3
    if run23:
        params = {'v': 1,
                  'chord': 1,
                  'aoa': np.arange(-10, 11, step=1).tolist(),
                  'panels': [80],
                  'problem': 'P2'}
        panel = vortexPanels(params)
        panel.problemTwoThree()

    # Show all of the plots
    plt.show()
