"""
-Parse data
-Complete each question for file
-Show and save all plots
"""

import os
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import statistics
import shutil
import scipy
from scipy import integrate, interpolate
from sympy import Symbol

# Parse data
class dataParse():
    def __init__(self, filenames, fft_filenames):
        self.data = {}
        self.fft_data = {}
        self.filenames = filenames
        self.fft_filenames = fft_filenames

        # Parse the data from the files
        dataParse.parseData(self)
        dataParse.parseFFT(self)

    # Parse the data (cylinder wake)
    def parseData(self):
        for file_loc in self.filenames:
            filename = os.path.basename(file_loc).replace('.csv', '')
            if filename != 'calibration':
                self.data[filename] = pd.DataFrame(pd.read_csv(file_loc,
                                                               delimiter=',',
                                                               na_values='.',
                                                               header=0,
                                                               names=['y pos', 'pitot vel', 'pitot std', 'hot vel', 'hot std']
                                                               ))
            else:
                self.data[filename] = pd.DataFrame(pd.read_csv(file_loc,
                                                               delimiter=',',
                                                               na_values='.',
                                                               header=0,
                                                               names=['pitot vel', 'hot volt']
                                                               ))

    # Parse the data (fft)
    def parseFFT(self):
        for file_loc in self.fft_filenames:
            filename = os.path.basename(file_loc).replace('.csv', '')
            self.fft_data[filename] = pd.DataFrame(pd.read_csv(file_loc,
                                                               delimiter=',',
                                                               na_values='.',
                                                               header=0,
                                                               names=['frequency', 'amplitude']
                                                               ))


# Analysis of data
class dataAnalysis():
    def __init__(self, filenames, fft_filenames):
        parse = dataParse(filenames, fft_filenames)
        self.data = parse.data
        self.filenames = filenames
        self.fft_data = parse.fft_data
        self.fft_filenames = fft_filenames
        self.hot_vel = []           # m/s
        self.hot_volt = []          # volts
        self.pitot_vel = []         # m/s
        self.y_pos = []             # millimeters
        self.v_inf = []             # m/s
        self.v_hot = 0              # Interpolation function for the hot wire velocity given voltage
        self.plot_color = ['r', 'b', 'g', 'k', 'y']
        self.cal_coeffs = [15.009, -80.758, 177.953, -185.689, 75.546]  # a_4 to a_0 from calibration
        self.v_inf = {'66.7': 25.301, '104.8': 25.287, '161.9': 25.326, '238.1': 25.293}

        # Constants
        self.wire_diam = .005       # millimeters
        self.cylinder_diam = 19.05  # millimeters
        self.w = 0.3048             # meters (12 inches)
        self.L = 0.1524             # meters (6 inches)
        self.atm_press = 99600      # Pa
        self.atm_temp = 298.15      # Kelvin (25 C)
        self.atm_density = 1.165    # kg/m^3
        self.b = 1.458*10**-6       # kg/(m s K^.5) (for visc calc)
        self.S = 110.4              # Kelvin (for visc calc)

        # Run problems
        dataAnalysis.problemOne(self)
        dataAnalysis.problemTwo(self)
        dataAnalysis.problemThree(self)
        dataAnalysis.problemFour(self)
        dataAnalysis.problemFive(self)
        #plt.show()

    # Problem 1
    def problemOne(self):
        """
        Tabulate hotwire calibration coefficients. Plot calibration curve, pitot velocity and hotwire velocity vs
        hotwire voltage
        U = a_o + a_1*E_v + a_2*E_v^2 + a_3*E_v^3 + a_4*E_v^4
        Where E_v is voltage of hotwire and U is velocity
            Use the coefficients from the calibration data
        """
        self.hot_volt = self.data['calibration']['hot volt'].tolist()
        self.pitot_vel = self.data['calibration']['pitot vel'].tolist()
        # Create interpolation function of FFT data for finding coefficients
        self.v_hot = np.poly1d(np.array(self.cal_coeffs))
        #print(self.v_hot)
        # Create string to print coefficients on plot
        print_coeffs = 'Curve Coefficients:'
        coeff_index = [4, 3, 2, 1, 0]
        for i in range(0, 5):
            print_coeffs += f'\n$a_{i}$ = {self.cal_coeffs[coeff_index[i]]}'
        # Create curve fit data to plot
        fit_plot_y = [self.v_hot(j) for j in self.hot_volt]
        # Plot velocities vs voltage
        plot_1 = plt.figure(figsize=(8, 8))
        vv = plot_1.add_subplot(1, 1, 1)
        props = dict(boxstyle='round', facecolor='white', alpha=0.2)
        vv.set_xlabel('Hotwire $E_v$ [Volts]', fontsize=14)
        vv.set_ylabel('Velocity [m/s]', fontsize=14)
        vv.grid(linewidth=0.5, color='gray', linestyle='--')
        vv.plot(self.hot_volt, fit_plot_y, color='k', linewidth=1, label='Hotwire Curve Fit')
        vv.scatter(self.hot_volt, self.pitot_vel, color='r', s=15, label='Pitot Exp. Data', marker='o')
        vv.text(0.02, 0.9, print_coeffs, transform=vv.transAxes, fontsize=11, verticalalignment='top', bbox=props)
        vv.legend(loc='upper left')
        plot_1.savefig(os.path.join(os.getcwd(), r'plots\prob1'))
        plt.draw()

    # Problem 2
    def problemTwo(self):
        """
        On a single plot, graph the mean velocity profiles measured at the four streamwise locations using both pitot
        and hotwire data. Make figure size large, fit one page. Normalize the velocity profiles by the freestream
        velocity
        """
        # Initialize plot figure
        plot_2 = plt.figure(figsize=(14, 10))
        plot_2.subplots_adjust(left=.15, right=.95, top=.95, bottom=.15)
        mv = plot_2.add_subplot(1, 1, 1)
        mv.set_xlabel('$\\frac{(y-y_o)}{D}$', fontsize=18)
        mv.set_ylabel('$\\frac{u(y)}{U_{\infty}}$', fontsize=18)
        mv.grid(linewidth=0.5, color='gray', linestyle='--')
        # Get plot data from each file
        for file_loc in self.filenames:
            file = os.path.basename(file_loc).replace('.csv', '')
            index = self.filenames.index(file_loc)
            if 'calibration' not in file:
                self.hot_vel = self.data[file]['hot vel'].tolist()
                self.pitot_vel = self.data[file]['pitot vel'].tolist()
                self.y_pos = self.data[file]['y pos'].tolist()
                # Calc the v_inf for the hotwire and pitot velocity profiles
                v_inf_hot = sum(self.hot_vel[::6])/len(self.hot_vel[::6])
                v_inf_pitot = sum(self.pitot_vel[::6])/len(self.pitot_vel[::6])
                # Normalize velocity to the freestream velocity
                hot_nondim = [i/v_inf_hot for i in self.hot_vel]
                pitot_nondim = [i/v_inf_pitot for i in self.pitot_vel]
                # Normalize the y position with cylinder diameter
                y0_hot = self.y_pos[hot_nondim.index(min(hot_nondim))]
                y0_pitot = self.y_pos[pitot_nondim.index(min(pitot_nondim))]
                y_pos_nondim_hot = [(i-y0_hot)/self.cylinder_diam for i in self.y_pos]
                y_pos_nondim_pitot = [(i - y0_pitot) / self.cylinder_diam for i in self.y_pos]
                # Plot the mean velocity
                mv.plot(y_pos_nondim_hot, hot_nondim, color=self.plot_color[index], label=f'Hotwire @ {file}mm')
                mv.plot(y_pos_nondim_pitot, pitot_nondim, color=self.plot_color[index], label=f'Pitot @ {file}mm', linestyle='--')
        mv.legend(loc='lower right')
        plot_2.savefig(os.path.join(os.getcwd(), r'plots\prob2'))
        plt.draw()

    # Problem 3
    def problemThree(self):
        """
        Use momentum deficit method to tabulate streamwise location of the cylinder, reynolds number, drag force, and
        drag coefficient given mean velocity profiles.
        Momentum deficit: F_D = rho*w*integral(-L)(L) (u_3(y))(U_1 - u_3(y))dy
            Where L is half the height of the control volume, U_1 is the free stream velocity, u_3 is streamwise
            velocity in the wake, and w is length of cylinder
        """
        data_text = 'Position (mm), F_D hotwire [N], C_D hotwire, Re hotwire, F_D pitot [N], C_D pitot, Re pitot'
        for file_loc in self.filenames:
            file = os.path.basename(file_loc).replace('.csv', '')
            if 'calibration' not in file:
                self.hot_vel = self.data[file]['hot vel'].tolist()
                self.pitot_vel = self.data[file]['pitot vel'].tolist()
                self.y_pos = self.data[file]['y pos'].tolist()
                # Calc the v_inf for the hotwire and pitot velocity profiles
                v_inf_hot = sum(self.hot_vel[::6])/len(self.hot_vel[::6])
                v_inf_pitot = sum(self.pitot_vel[::6])/len(self.pitot_vel[::6])
                # Normalize velocity to the freestream velocity
                hot_nondim = [i/v_inf_hot for i in self.hot_vel]
                pitot_nondim = [i/v_inf_pitot for i in self.pitot_vel]
                # Normalize the y position with cylinder diameter
                y0_hot = self.y_pos[hot_nondim.index(min(hot_nondim))]
                y0_pitot = self.y_pos[pitot_nondim.index(min(pitot_nondim))]
                y_pos_nondim_hot = [(i-y0_hot)/self.cylinder_diam for i in self.y_pos]
                y_pos_nondim_pitot = [(i - y0_pitot) / self.cylinder_diam for i in self.y_pos]
                # Create interpolation function of the hot and pitot data for integration
                hot_interp = np.poly1d(np.polyfit(y_pos_nondim_hot, self.hot_vel, 14))
                pitot_interp = np.poly1d(np.polyfit(y_pos_nondim_pitot, self.pitot_vel, 14))
                hot_integ = (hot_interp*(hot_interp - v_inf_hot)).integ()
                pitot_integ = (pitot_interp*(pitot_interp - v_inf_pitot)).integ()
                # Calculate drag force using momentum deficit method
                F_D_hot = hot_integ(self.L) * 2
                F_D_pitot = pitot_integ(self.L) * 2
                # Calculate the drag coefficient
                C_D_hot = F_D_hot/(.5 * self.atm_density * v_inf_hot**2 * (self.w*self.cylinder_diam))
                C_D_pitot = F_D_pitot/(.5 * self.atm_density * v_inf_hot**2 * (self.w*self.cylinder_diam))
                # Calculate Reynolds numbers
                mu = (self.b * self.atm_temp ** (3 / 2)) / (self.atm_temp + self.S)
                Re_hot = (self.atm_density * (self.cylinder_diam / 1000) * v_inf_hot) / mu
                Re_pitot = (self.atm_density * (self.cylinder_diam / 1000) * v_inf_pitot) / mu
                # Write values to data_text
                data_text += f'\n{file}, {F_D_hot}, {C_D_hot}, {Re_hot}, {F_D_pitot}, {C_D_pitot}, {Re_pitot}'
        # Write data_text to csv file
        with open('problem3_data.csv', 'wt') as f:
            f.write(data_text)
        print(data_text)

    # Problem 4
    def problemFour(self):
        """
        On separate plots for the hotwire and the pitot, plot the turbulence intensity (std dev/v_inf) at the four locations
        Make the plot large, one page. Y axis should be (y-y_0)/D
        """
        # Initialize plot figures
        plot_41 = plt.figure(figsize=(8, 10))
        plot_41.subplots_adjust(left=.15, right=.95, top=.95, bottom=.15)
        pitot = plot_41.add_subplot(1, 1, 1)
        pitot.set_xlabel('$\\frac{(y-y_o)}{D}$', fontsize=18)
        pitot.set_ylabel('Turbulence Intensity', fontsize=18)
        pitot.grid(linewidth=0.5, color='gray', linestyle='--')
        plot_42 = plt.figure(figsize=(8, 10))
        plot_42.subplots_adjust(left=.15, right=.95, top=.95, bottom=.15)
        hot = plot_42.add_subplot(1, 1, 1)
        hot.set_xlabel('$\\frac{(y-y_o)}{D}$', fontsize=18)
        hot.set_ylabel('Turbulence Intensity', fontsize=18)
        hot.grid(linewidth=0.5, color='gray', linestyle='--')
        # Get plot data from each file
        for file_loc in self.filenames:
            file = os.path.basename(file_loc).replace('.csv', '')
            index = self.filenames.index(file_loc)
            if 'calibration' not in file:
                self.hot_vel = self.data[file]['hot vel'].tolist()
                self.pitot_vel = self.data[file]['pitot vel'].tolist()
                self.y_pos = self.data[file]['y pos'].tolist()
                # Calc v_inf for hotwire and pitot velocity profiles
                v_inf_hot = sum(self.hot_vel[::6]) / len(self.hot_vel[::6])
                v_inf_pitot = sum(self.pitot_vel[::6]) / len(self.pitot_vel[::6])
                # Normalize velocity to the freestream velocity
                hot_nondim = [i / v_inf_hot for i in self.hot_vel]
                pitot_nondim = [i / v_inf_pitot for i in self.pitot_vel]
                # Normalize the y position with cylinder diameter
                y0_hot = self.y_pos[hot_nondim.index(min(hot_nondim))]
                y0_pitot = self.y_pos[pitot_nondim.index(min(pitot_nondim))]
                y_pos_nondim_hot = [(i - y0_hot) / self.cylinder_diam for i in self.y_pos]
                y_pos_nondim_pitot = [(i - y0_pitot) / self.cylinder_diam for i in self.y_pos]
                # Calculate the standard deviation, normalize hotwire and pitot std dev to v_inf
                hot_std = statistics.stdev(self.hot_vel)/v_inf_hot
                pitot_std = statistics.stdev(self.pitot_vel)/v_inf_pitot
                # Get turbulence intensity
                hot_turb = [i*hot_std for i in self.hot_vel]
                pitot_turb = [i*pitot_std for i in self.pitot_vel]
                # Plot the turbulence intensity
                pitot.plot(y_pos_nondim_pitot, pitot_turb, color=self.plot_color[index], label=f'{file}mm')
                hot.plot(y_pos_nondim_hot, hot_turb, color=self.plot_color[index], label=f'{file}mm')
        pitot.legend(loc='lower right')
        hot.legend(loc='lower right')
        plot_41.savefig(os.path.join(os.getcwd(), r'plots\prob4_pitot'))
        plot_42.savefig(os.path.join(os.getcwd(), r'plots\prob4_hot'))
        plt.draw()

    # Problem 5
    def problemFive(self):
        """
        Plot FFT amplitude spectrum for all cases, limit x-axis to range of 0 to 1000 Hz.
        Tabulate Reynolds number, frequency, and magnitude of peak associated with the vortex shedding frequency, and
        calc the Strouhal number for each case
        Strouhal number = (shedding frequency * Diameter)/v_inf
        """
        # Initialize plot
        plot_5 = plt.figure(figsize=(15, 10))
        plot_5.subplots_adjust(left=.1, right=.95, top=.95, bottom=.1)
        fft = plot_5.add_subplot(1, 1, 1)
        fft.set_xlabel('Frequency [Hz]', fontsize=18)
        fft.set_ylabel('FFT Amplitude [Vrms]', fontsize=18)
        fft.set_xlim([0, 1000])
        fft.grid(linewidth=0.5, color='gray', linestyle='--')
        # Get data from files and plot
        data_text = 'V Infinity (m/s), Reynolds Number, Peak Vortex Amplitude (Vrms), ' \
                    'Frequency at Peak Amplitude (Hz), Strouhal Number'
        peak_a_list, peak_f_list = [], []
        for file_loc in self.fft_filenames:
            file = os.path.basename(file_loc).replace('.csv', '')
            index = self.fft_filenames.index(file_loc)
            amplitude = self.fft_data[file]['amplitude'].tolist()
            frequency = self.fft_data[file]['frequency'].tolist()
            v_inf = int(file)
            # Plot data
            fft.plot(frequency, amplitude, color=self.plot_color[index], linewidth=1.5, label=f'{file} m/s')
            # Calculate Reynolds number
            mu = (self.b * self.atm_temp**(3/2)) / (self.atm_temp + self.S)
            Re = (self.atm_density * (self.cylinder_diam/1000) * v_inf)/mu
            # Find peak frequency
            peak_f, peak_a = 0, 0
            for i in range(0, len(frequency)-1):
                a0 = amplitude[i]
                a1 = amplitude[i+1]
                f0 = frequency[i]
                f1 = frequency[i+1]
                slope = (a1 - a0)/(f1 - f0)
                if slope >= 0 and f0 >= 50 and a1 >= peak_a:
                    peak_f = f1
                    peak_a = a1
            peak_a_list.append(peak_a)
            peak_f_list.append(peak_f)
            # Calc Strouhal number
            strouhal = (peak_f * (self.cylinder_diam/1000))/v_inf
            # Save data to text
            data_text += f'\n{v_inf}, {round(Re, 5)}, {round(peak_a, 4)}, {round(peak_f, 5)}, {round(strouhal, 5)}'
        fft.scatter(peak_f_list, peak_a_list, edgecolors='k', facecolors='none', s=40, label='Peak Vortex Shedding Freq.')
        # Save data_text file
        with open('problem5_data.csv', 'wt') as f:
            f.write(data_text)
        fft.legend(loc='upper right')
        plot_5.savefig(os.path.join(os.getcwd(), r'plots\prob5'))
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

    data_file_loc = os.path.join(os.getcwd(), 'lab6_data_cylinder')
    data_filenames = [os.path.join(data_file_loc, i) for i in os.listdir(data_file_loc)]
    fft_file_loc = os.path.join(os.getcwd(), 'lab6_data_fft')
    fft_filenames = [os.path.join(fft_file_loc, i) for i in os.listdir(fft_file_loc)]

    # Run Analysis
    dataAnalysis(data_filenames, fft_filenames)

