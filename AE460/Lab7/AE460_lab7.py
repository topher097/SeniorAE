import os
import shutil
import pandas as pd
import matplotlib.pyplot as plt
import scipy.interpolate


class labSeven():
    def __init__(self, filenames):
        # Stuff
        print(filenames)
        self.filenames = filenames
        self.non_dry_files = []
        self.parsed = {}
        self.file = ''
        self.colors = ['r', 'b', 'y', 'k', 'orange']

        # Variables
        self.corr_factor = 0.94
        self.length_scale = 1.3125
        self.amb_press = 14.5331285
        self.amb_temp = 531.27
        self.density = 0.002295562
        self.viscocity = 3.8073E-07

        # Dictionary
        self.motor_speed = {}
        self.alpha = {}
        self.q = {}
        self.v_avg = {}
        self.re = {}
        self.F_a = {}
        self.F_n = {}
        self.M = {}

        # Calculated
        self.lift = {}
        self.drag = {}
        self.l_d = {}
        self.moment = {}

        for i in self.filenames:
            self.file = i
            labSeven.parse(self)

        # Calculate lift, drag, moment
        labSeven.calc(self)

        # Plot data
        labSeven.plot(self)

    def parse(self):
        # Load CSV file into a DataFrame
        print(self.file)
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

        # Calc corrected F_a and F_n, store in lift and drag dicts
        for file in self.filenames:
            if 'Dry' not in file:
                self.non_dry_files.append(file)
                lift = []
                drag = []
                moment = []
                for i in range(len(self.alpha[file])):
                    alpha = self.alpha[file][i]
                    F_n = self.F_n[file][i]
                    F_a = self.F_a[file][i]
                    M = self.M[file][i]
                    lift.append(F_n - corr_F_n(alpha))
                    drag.append(F_a - corr_F_a(alpha))
                    moment.append(M - corr_M(alpha))
                self.lift[file] = lift
                self.drag[file] = drag
                self.moment[file] = moment
                self.l_d[file] = [x/y for x, y in zip(lift, drag)]

    def plot(self):
        s = 3
        w = 1
        f = 10
        fig1 = plt.figure()
        fig2 = plt.figure()
        fig3 = plt.figure()
        fig4 = plt.figure()
        plot_lift = fig1.add_subplot(111)
        plot_drag = fig2.add_subplot(111)
        plot_moment = fig3.add_subplot(111)
        plot_l_d = fig4.add_subplot(111)
        plot_lift.grid(color='grey', ls='--', lw=0.5)
        plot_drag.grid(color='grey', ls='--', lw=0.5)
        plot_moment.grid(color='grey', ls='--', lw=0.5)
        plot_l_d.grid(color='grey', ls='--', lw=0.5)
        plot_lift.set_xlabel('Angle of Attack [deg]', fontsize=f)
        plot_drag.set_xlabel('Angle of Attack [deg]', fontsize=f)
        plot_moment.set_xlabel('Angle of Attack [deg]', fontsize=f)
        plot_l_d.set_xlabel('Angle of Attack [deg]', fontsize=f)
        plot_lift.set_ylabel('Lift Force [lbs]', fontsize=f)
        plot_drag.set_ylabel('Drag Force [lbs]', fontsize=f)
        plot_moment.set_ylabel('Pitching Moment [lbs/in]', fontsize=f)
        plot_l_d.set_ylabel('L/D', fontsize=f)

        for file in self.non_dry_files:
            alpha = self.alpha[file]
            lift = self.lift[file]
            drag = self.drag[file]
            moment = self.moment[file]
            l_d = self.l_d[file]
            airspeed = os.path.basename(file).replace('.csv', '')
            c = self.colors[self.non_dry_files.index(file)]

            plot_lift.plot(alpha, lift, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                           label=f'{airspeed} ft/s')
            plot_drag.plot(alpha, drag, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                           label=f'{airspeed} ft/s')
            plot_moment.plot(alpha, moment, marker='o', mfc=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                             label=f'{airspeed} ft/s')
            plot_l_d.plot(alpha, l_d, marker='o', markerfacecolor=None, markeredgecolor=c, color=c, ls='--', lw=w, ms=s,
                          label=f'{airspeed} ft/s')
        plot_lift.legend(loc='lower right', fontsize=12)
        plot_drag.legend(loc='lower right', fontsize=12)
        plot_moment.legend(loc='lower right', fontsize=12)
        plot_l_d.legend(loc='lower right', fontsize=12)
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

    # Get the filenames to parse, calc, and plot
    data_location = os.path.join(os.getcwd() + r'\Lab7_Data')
    # Create file location paths for parser
    files = []
    filenames = [['Dry', '50', '75', '100'], ['Side_Dry', 'Side_75']]
    for file in filenames:
        files = [os.path.join(data_location, i + '.csv') for i in file]
        print(files)
        lab7 = labSeven(files)
    plt.show()
