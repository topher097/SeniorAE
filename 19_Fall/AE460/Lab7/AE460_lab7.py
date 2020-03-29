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
        self.S = 10.84                  # in^2
        self.LE_to_M_distance = 5.32    # in
        self.dist_np = {'50': 3.97,
                        '75': 3.87,
                        '100': 3.90}

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
        self.M_np = {}
        self.Lift = {}

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
                    Lift = []
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
                        D = F_a*cos(a) - F_n*sin(a)     # lbs
                        L = F_a*sin(a) - F_n*cos(a)     # lbs
                        M_LE = -1*((M - corr_M(alpha)) + L*cos(a)*self.LE_to_M_distance)        # in-lbf
                        C_L.append(L/((q)*self.S))
                        C_D.append(D/((q)*self.S))
                        C_M_LE.append(M_LE/(q*self.S**2))
                        Lift.append(L)
                    self.C_L[file] = C_L
                    self.C_D[file] = C_D
                    self.C_M_LE[file] = C_M_LE
                    self.F_n_corrected[file] = F_n_list
                    self.F_a_corrected[file] = F_a_list
                    self.M_corrected[file] = M_list
                    self.Lift[file] = Lift

        # Calc the moment about the neutral point
        for file in self.filenames:
            if 'Dry' not in file and 'xflr' not in file:
                M_np = []
                # Go through each angle of attack
                for i in range(len(self.alpha[file])):
                    # Find speed of freestream for x_np
                    airspeed = str(os.path.basename(file).replace('.csv', ''))
                    alpha = self.alpha[file][i]
                    F_n = self.F_n_corrected[file][i]
                    F_a = self.F_a_corrected[file][i]
                    M = self.M_corrected[file][i]
                    x = self.dist_np[airspeed]
                    y = 0       # estimation of y location (in) of neutral point with respect to the axis of measurement

                    if '100' in file:
                        a = np.deg2rad(alpha)
                        #print(alpha)
                        #print(F_n*cos(a) + F_a*sin(a))
                    # Calc the moment at the neutral point (only consider the x position)
                    M_np_val = M - (F_n*x+F_a*y)
                    M_np.append(M_np_val)
                self.M_np[file] = M_np

    def plotC(self):
        s = 3           # Marker size
        w = 1.5         # Linewidth
        f = 16          # Fontsize
        wp = 7          # width of plot size
        hp = 5.5          # height of plot figure
        fig1 = plt.figure(figsize=(wp, hp))     # C_L vs alpha
        fig2 = plt.figure(figsize=(wp, hp))     # C_D vs alpha
        fig3 = plt.figure(figsize=(wp, hp))     # C_Mle vs alpha
        fig4 = plt.figure(figsize=(wp, hp))     # C_L vs C_D
        fig5 = plt.figure(figsize=(wp, hp))     # C_L^3/2 vs alpha
        fig6 = plt.figure(figsize=(wp, hp))     # LD vs alpha
        fig7 = plt.figure(figsize=(wp, hp))     # M_np vs alpha (neutral points)
        fig8 = plt.figure(figsize=(wp, hp))     # Fn vs alpha
        fig9 = plt.figure(figsize=(wp, hp))     # Fa vs alpha
        fig10 = plt.figure(figsize=(wp, hp))    # M vs alpha
        fig11 = plt.figure(figsize=(wp, hp))    # L vs alpha
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
        plot_LD = fig6.add_subplot(111)
        plot_LD.grid(color='grey', ls='--', lw=0.5)
        plot_LD.set_xlabel('$\\alpha$ [deg]', fontsize=f)
        plot_LD.set_ylabel('L/D', fontsize=f)
        plot_Mnp = fig7.add_subplot(111)
        plot_Mnp.grid(color='grey', ls='--', lw=0.5)
        plot_Mnp.set_xlabel('$\\alpha$ [deg]', fontsize=f)
        plot_Mnp.set_ylabel('$M_{NP}$ [in-lbf]', fontsize=f)
        plot_Fn = fig8.add_subplot(111)
        plot_Fn.grid(color='grey', ls='--', lw=0.5)
        plot_Fn.set_xlabel('$\\alpha$ [deg]', fontsize=f)
        plot_Fn.set_ylabel('$F_{n}$ [lbf]', fontsize=f)
        plot_Fa = fig9.add_subplot(111)
        plot_Fa.grid(color='grey', ls='--', lw=0.5)
        plot_Fa.set_xlabel('$\\alpha$ [deg]', fontsize=f)
        plot_Fa.set_ylabel('$F_{a}$ [lbf]', fontsize=f)
        plot_M = fig10.add_subplot(111)
        plot_M.grid(color='grey', ls='--', lw=0.5)
        plot_M.set_xlabel('$\\alpha$ [deg]', fontsize=f)
        plot_M.set_ylabel('$M_{sting}$ [in-lbf]', fontsize=f)
        plot_L = fig11.add_subplot(111)
        plot_L.grid(color='grey', ls='--', lw=0.5)
        plot_L.set_xlabel('$\\alpha$ [deg]', fontsize=f)
        plot_L.set_ylabel('$L$ [lbf]', fontsize=f)

        for file in self.non_dry_files:
            c = ''
            if '50' in file:
                c = 'r'
            elif '75' in file:
                c = 'b'
            elif '100' in file:
                c = 'orange'

            if 'xflr' not in file:
                alpha = self.alpha[file]
                F_n = self.F_n_corrected[file]
                F_a = self.F_a_corrected[file]
                M = self.M_corrected[file]
                L = self.Lift[file]
                C_L = self.C_L[file]
                C_D = self.C_D[file]
                C_M_LE = self.C_M_LE[file]
                M_np = self.M_np[file]
                alpha_mod1, alpha_mod2 = [], []
                LD32, LD = [], []
                for i in range(len(C_L)):
                    if np.real(C_L[i] ** (3 / 2) / C_D[i]) >= 0:
                        alpha_mod1.append(alpha[i])
                        LD32.append(np.real(C_L[i] ** (3 / 2) / C_D[i]))
                    LD.append((C_L[i] / C_D[i]))

                Re = int(statistics.mean(self.re[file]))

                plot_C_L.plot(alpha, C_L, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                               label=f'Exp. Re = {Re}')
                plot_C_D.plot(alpha, C_D, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                               label=f'Exp. Re = {Re}')
                plot_C_M_LE.plot(alpha, C_M_LE, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                                 label=f'Exp. Re = {Re}')
                plot_l_d.plot(C_D, C_L, marker='o', markerfacecolor=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                              label=f'Exp. Re = {Re}')
                plot_CL32.plot(alpha_mod1, LD32, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                               label=f'Exp. Re = {Re}')
                plot_LD.plot(alpha, LD, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                                  label=f'Exp. Re = {Re}')
                plot_Mnp.plot(alpha, M_np, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                               label=f'Exp. Re = {Re}')
                plot_Fn.plot(alpha, F_n, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                              label=f'Exp. Re = {Re}')
                plot_Fa.plot(alpha, F_a, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                              label=f'Exp. Re = {Re}')
                plot_M.plot(alpha, M, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                              label=f'Exp. Re = {Re}')
                plot_L.plot(alpha, L, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                            label=f'Exp. Re = {Re}')
            else:
                alpha = self.alpha[file]
                C_L = self.C_L[file]
                C_D = self.C_D[file]
                C_M_LE = self.C_M_LE[file]
                alpha_mod1, alpha_mod2 = [], []
                LD32, LD = [], []
                for i in range(len(C_L)):
                    if np.real(C_L[i] ** (3 / 2) / C_D[i]) >= 0:
                        alpha_mod1.append(alpha[i])
                        LD32.append(np.real(C_L[i] ** (3 / 2) / C_D[i]))
                    LD.append((C_L[i] / C_D[i]))
                airspeed = int(os.path.basename(file).replace('.csv', '').replace('xflr', ''))
                rho = self.density
                l = self.length_scale/12
                mu = self.viscocity
                Re = int((rho*airspeed*l)/mu)

                plot_C_L.plot(alpha, C_L, color=c, lw=w, label=f'Theory Re = {Re}')
                plot_C_D.plot(alpha, C_D, color=c, lw=w, label=f'Theory Re = {Re}')
                plot_C_M_LE.plot(alpha, C_M_LE, color=c, lw=w, label=f'Theory Re = {Re}')
                plot_l_d.plot(C_D, C_L, color=c, lw=w, label=f'Theory Re = {Re}')
                plot_CL32.plot(alpha_mod1, LD32, color=c, lw=w, label=f'Theory Re = {Re}')
                plot_LD.plot(alpha, LD, color=c, lw=w, label=f'Theory Re = {Re}')
        f2 = 12     # legend fontsize
        plot_C_L.legend(loc='lower right', fontsize=f2)
        plot_C_D.legend(loc='upper left', fontsize=f2)
        plot_C_M_LE.legend(loc='upper right', fontsize=f2)
        plot_l_d.legend(loc='lower right', fontsize=f2)
        plot_LD.legend(loc='lower right', fontsize=f2)
        plot_CL32.legend(loc='upper left', fontsize=f2)
        plot_Mnp.legend(loc='lower left', fontsize=f2)
        plot_Fn.legend(loc='upper left', fontsize=f2)
        plot_Fa.legend(loc='lower left', fontsize=f2)
        plot_M.legend(loc='upper left', fontsize=f2)
        plot_L.legend(loc='upper left', fontsize=f2)
        plt.draw()
        fig1.savefig(os.path.join(os.getcwd(), r'plots\CL_alpha'))
        fig2.savefig(os.path.join(os.getcwd(), r'plots\CD_alpha'))
        fig3.savefig(os.path.join(os.getcwd(), r'plots\CM_alpha'))
        fig4.savefig(os.path.join(os.getcwd(), r'plots\CL_CD'))
        fig5.savefig(os.path.join(os.getcwd(), r'plots\L32D_alpha'))
        fig6.savefig(os.path.join(os.getcwd(), r'plots\LD_alpha'))
        fig7.savefig(os.path.join(os.getcwd(), r'plots\Mnp_alpha'))
        fig8.savefig(os.path.join(os.getcwd(), r'plots\Fn_alpha'))
        fig9.savefig(os.path.join(os.getcwd(), r'plots\Fa_alpha'))
        fig10.savefig(os.path.join(os.getcwd(), r'plots\M_alpha'))
        fig11.savefig(os.path.join(os.getcwd(), r'plots\L_alpha'))


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
    filenames = [['Dry', '100', '75', '50', 'xflr100', 'xflr75', 'xflr50']]    # , ['Side_Dry', 'Side_75']
    for file in filenames:
        files = [os.path.join(data_location, i + '.csv') for i in file]
        lab7 = labSeven(files)
    plt.show()
