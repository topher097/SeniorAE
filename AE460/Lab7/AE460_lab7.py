import os
import shutil
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scipy.interpolate
from math import cos, sin
import statistics


class labSeven():
    def __init__(self, filenames):
        # Stuff
        self.filenames = filenames
        self.non_dry_files = []
        self.parsed = {}
        self.file = ''
        self.colors = ['r', 'b', 'y', 'k', 'orange']

        # Variables
        self.corr_factor = 0.94
        self.length_scale = 1.3125      # in
        self.amb_press = 14.5331285     # psia
        self.amb_temp = 531.27          # R
        self.density = 0.002295562      # slug/ft^3
        self.viscocity = 3.8073E-07     # slug/ft-s
        self.S = 10.87                  # in^2
        self.LE_to_M_distance = 5.32    # in

        # Dictionary (lab data)
        self.motor_speed = {}           # RPM
        self.alpha = {}                 # deg
        self.q = {}                     # dpsi
        self.v_avg = {}                 # ft/s
        self.re = {}                    # Reynolds
        self.F_a = {}                   # lbf
        self.F_n = {}                   # lbf
        self.M = {}                     # in-lbf

        # Dictionary (xflr)
        self.xflr_alpha = {}
        self.xflr_C_L = {}
        self.xflr_C_D = {}
        self.xflr_C_MLE = {}

        # Calculated
        self.C_L = {}
        self.C_D = {}
        self.l_d = {}
        self.C_M_LE = {}
        self.F_n_corrected = {}
        self.F_a_corrected = {}
        self.M_corrected = {}

        for i in self.filenames:
            self.file = i
            if 'xflr' not in self.file:
                labSeven.parse(self)
            else:
                labSeven.parseXFLR(self)

        # Calculate C_L, C_D, C_M_LE
        labSeven.calc(self)

        # Plot data
        labSeven.plotC(self)

    def parse(self):
        # Load CSV file into a DataFrame
        self.parsed = pd.DataFrame(pd.read_csv(self.file,
                                               delimiter=',',
                                               na_values='.',
                                               header=0,
                                               names=['d_p', 'c_f', 'l_s', 'a_p', 'a_t', 'density', 'viscocity',
                                                      'motor_speed', 'alpha', 'q', 'v_avg', 're', 'F_a', 'F_n', 'M']
                                               ))

        self.motor_speed[self.file] = self.parsed['motor_speed'].tolist()
        self.alpha[self.file] = self.parsed['alpha'].tolist()
        self.q[self.file] = self.parsed['q'].tolist()
        self.v_avg[self.file] = self.parsed['v_avg'].tolist()
        self.re[self.file] = self.parsed['re'].tolist()
        self.F_a[self.file] = self.parsed['F_a'].tolist()
        self.F_n[self.file] = self.parsed['F_n'].tolist()
        self.M[self.file] = self.parsed['M'].tolist()
        
    def parseXFLR(self):
        # Load CSV file into a DataFrame
        self.parsed = pd.DataFrame(pd.read_csv(self.file,
                                               delimiter=',',
                                               na_values='.',
                                               header=0,
                                               names=['alpha', 'beta', 'CL', 'CDi', 'CDv', 'CD', 'CY',
                                                      'Cl', 'Cm', 'Cn', 'Cni', 'q', 'x_cp']
                                               ))

        self.alpha[self.file] = self.parsed['alpha'].tolist()
        self.C_L[self.file] = self.parsed['CL'].tolist()
        self.C_D[self.file] = self.parsed['CD'].tolist()
        self.C_M_LE[self.file] = self.parsed['Cm'].tolist()

    def calc(self):
        # Get dry run data, make interpolation functions for corrections wrt alpha
        corr_F_n = None
        corr_F_a = None
        corr_M = None
        for file in self.filenames:
            if 'Dry' in file:
                dry_alpha = self.alpha[file]
                dry_F_a = self.F_a[file]
                dry_F_n = self.F_n[file]
                dry_M = self.M[file]
                corr_F_a = scipy.interpolate.CubicSpline(dry_alpha, dry_F_a)
                corr_F_n = scipy.interpolate.CubicSpline(dry_alpha, dry_F_n)
                corr_M = scipy.interpolate.CubicSpline(dry_alpha, dry_M)
                break

        # Calc corrected F_a, F_n, M, calc C_L, C_D, C_MLE and store in dicts
        for file in self.filenames:
            if 'Dry' not in file:
                self.non_dry_files.append(file)
                if 'xflr' not in file:
                    C_L = []
                    C_D = []
                    C_M_LE = []
                    F_n_list = []
                    F_a_list = []
                    M_list = []
                    # Go through each angle of attack
                    for i in range(len(self.alpha[file])):
                        alpha = self.alpha[file][i]
                        q = self.q[file][i]
                        F_n = self.F_n[file][i] - corr_F_n(alpha)
                        F_a = self.F_a[file][i] - corr_F_a(alpha)
                        M = self.M[file][i] - corr_M(alpha)
                        a = np.deg2rad(alpha)
                        F_n_list.append(F_n)
                        F_a_list.append(F_a)
                        M_list.append(M)
                        D = F_a*cos(a) + F_n*sin(a)     # lbs
                        L = F_a*sin(a) + F_n*cos(a)     # lba
                        M_LE = -1*((M - corr_M(alpha)) + L*cos(a)*self.LE_to_M_distance)        # in-lbf
                        C_L.append(L/((q)*self.S))
                        C_D.append(D/((q)*self.S))
                        C_M_LE.append(M_LE/(q*self.S**2))
                    self.C_L[file] = C_L
                    self.C_D[file] = C_D
                    self.C_M_LE[file] = C_M_LE
                    self.F_n_corrected[file] = F_n_list
                    self.F_a_corrected[file] = F_a_list
                    self.M_corrected[file] = M_list

    def plotC(self):
        s = 3
        w = 1.5
        f = 14
        fig1 = plt.figure()
        fig2 = plt.figure()
        fig3 = plt.figure()
        fig4 = plt.figure()
        fig5 = plt.figure()
        fig6 = plt.figure()
        plot_C_L = fig1.add_subplot(111)
        plot_C_L.grid(color='grey', ls='--', lw=0.5)
        plot_C_L.set_xlabel('$\\alpha$ [deg]', fontsize=f)
        plot_C_L.set_ylabel('$C_{L}$', fontsize=f)
        plot_C_D = fig2.add_subplot(111)
        plot_C_D.grid(color='grey', ls='--', lw=0.5)
        plot_C_D.set_xlabel('$\\alpha$ [deg]', fontsize=f)
        plot_C_D.set_ylabel('$C_{D}$', fontsize=f)
        plot_C_M_LE = fig3.add_subplot(111)
        plot_C_M_LE.grid(color='grey', ls='--', lw=0.5)
        plot_C_M_LE.set_xlabel('$\\alpha$ [deg]', fontsize=f)
        plot_C_M_LE.set_ylabel('$C_{M_{LE}}$', fontsize=f)
        plot_l_d = fig4.add_subplot(111)
        plot_l_d.grid(color='grey', ls='--', lw=0.5)
        plot_l_d.set_xlabel('$C_{D}$', fontsize=f)
        plot_l_d.set_ylabel('$C_{L}$', fontsize=f)
        plot_CL32 = fig5.add_subplot(111)
        plot_CL32.grid(color='grey', ls='--', lw=0.5)
        plot_CL32.set_xlabel('$\\alpha$ [deg]', fontsize=f)
        plot_CL32.set_ylabel('$C^{3/2}_{L}$/$C_{D}$', fontsize=f)
        plot_CL12 = fig6.add_subplot(111)
        plot_CL12.grid(color='grey', ls='--', lw=0.5)
        plot_CL12.set_xlabel('$\\alpha$ [deg]', fontsize=f)
        plot_CL12.set_ylabel('$C^{1/2}_{L}$/$C_{D}$', fontsize=f)

        for file in self.non_dry_files:
            c = ''
            if '50' in file or '15.2' in file:
                c = 'r'
            elif '75' in file or '22.9' in file:
                c = 'b'
            elif '100' in file or '30.5' in file:
                c = 'orange'

            if 'xflr' not in file:
                alpha = self.alpha[file]
                C_L = self.C_L[file]
                C_D = self.C_D[file]
                C_M_LE = self.C_M_LE[file]
                alpha_mod1, alpha_mod2 = [], []
                LD32, LD12 = [], []
                for i in range(len(C_L)):
                    if np.real(C_L[i] ** (3 / 2) / C_D[i]) >= 0:
                        alpha_mod1.append(alpha[i])
                        LD32.append(np.real(C_L[i] ** (3 / 2) / C_D[i]))
                    if np.real(C_L[i] ** (1 / 2) / C_D[i]) >= 0:
                        alpha_mod2.append(alpha[i])
                        LD12.append(np.real(C_L[i] ** (1 / 2) / C_D[i]))

                Re = int(statistics.mean(self.re[file]))

                plot_C_L.plot(alpha, C_L, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                               label=f'Exp. Re = {Re}')
                plot_C_D.plot(alpha, C_D, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                               label=f'Exp. Re = {Re}')
                plot_C_M_LE.plot(alpha, C_M_LE, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                                 label=f'Exp. Re = {Re}')
                plot_l_d.plot(C_D, C_L, marker='o', markerfacecolor=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                              label=f'Exp. Re = {Re}')
                plot_CL32.plot(LD32, alpha_mod1, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                               label=f'Exp. Re = {Re}')
                plot_CL12.plot(LD12, alpha_mod2, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                                  label=f'Exp. Re = {Re}')
            else:
                print(file, 'hi')
                alpha = self.alpha[file]
                C_L = self.C_L[file]
                C_D = self.C_D[file]
                C_M_LE = self.C_M_LE[file]
                alpha_mod1, alpha_mod2 = [], []
                LD32, LD12 = [], []
                for i in range(len(C_L)):
                    if np.real(C_L[i] ** (3 / 2) / C_D[i]) >= 0:
                        alpha_mod1.append(alpha[i])
                        LD32.append(np.real(C_L[i] ** (3 / 2) / C_D[i]))
                    if np.real(C_L[i] ** (1 / 2) / C_D[i]) >= 0:
                        alpha_mod2.append(alpha[i])
                        LD12.append(np.real(C_L[i] ** (1 / 2) / C_D[i]))
                print(LD32)
                airspeed = int(float(os.path.basename(file).replace('.csv', '').replace('xflr_', '').replace('ms', '')) * 3.28084)
                rho = self.density
                l = self.length_scale/12
                mu = self.viscocity
                Re = int((rho*airspeed*l)/mu)

                plot_C_L.plot(alpha, C_L, color=c, lw=w, label=f'Theory Re = {Re}')
                plot_C_D.plot(alpha, C_D, color=c, lw=w, label=f'Theory Re = {Re}')
                plot_C_M_LE.plot(alpha, C_M_LE, color=c, lw=w, label=f'Theory Re = {Re}')
                plot_l_d.plot(C_D, C_L, color=c, lw=w, label=f'Theory Re = {Re}')
                plot_CL32.plot(LD32, alpha_mod1, color=c, lw=w, label=f'Theory Re = {Re}')
                plot_CL12.plot(LD12, alpha_mod2, color=c, lw=w, label=f'Theory Re = {Re}')

        plot_C_L.legend(loc='lower right', fontsize=10)
        plot_C_D.legend(loc='upper left', fontsize=10)
        plot_C_M_LE.legend(loc='upper right', fontsize=10)
        plot_l_d.legend(loc='lower right', fontsize=10)
        plot_CL12.legend(loc='upper left', fontsize=10)
        plot_CL32.legend(loc='upper left', fontsize=10)
        plt.draw()
        fig1.savefig(os.path.join(os.getcwd(), r'plots\CL_alpha'))
        fig2.savefig(os.path.join(os.getcwd(), r'plots\CD_alpha'))
        fig3.savefig(os.path.join(os.getcwd(), r'plots\CM_alpha'))
        fig4.savefig(os.path.join(os.getcwd(), r'plots\LD'))
        fig5.savefig(os.path.join(os.getcwd(), r'plots\L32D_alpha'))
        fig6.savefig(os.path.join(os.getcwd(), r'plots\L12D_alpha'))


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

    # Get the filenames to parse, calc, and plot
    data_location = os.path.join(os.getcwd() + r'\Lab7_Data')
    # Create file location paths for parser
    files = []
    filenames = [['Dry', '50', '75', '100', 'xflr_15.2ms', 'xflr_22.9ms', 'xflr_30.5ms']]    # , ['Side_Dry', 'Side_75']
    for file in filenames:
        files = [os.path.join(data_location, i + '.csv') for i in file]
        lab7 = labSeven(files)
    plt.show()
