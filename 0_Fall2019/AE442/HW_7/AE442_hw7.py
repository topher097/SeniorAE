import numpy as np
import matplotlib.pyplot as plt
import os
from collections import Counter
import shutil

# Parse the data from excel optimization file (take relative data only)
class parseData():
    def __init__(self):
        self.filename = os.path.join(os.getcwd(), r'Data\747_parse3.csv')
        self.R = []                   # range
        self.BFL = []                 # balanced field length
        self.MRW = []                 # max ramp weight
        self.AR = []                  # aspect ratio
        self.S = []                   # reference area
        self.f_l = []                 # fuselage length
        self.SFC = []                 # specific fuel ratio
        self.FN = []                  # total thrust
        self.W_fuel = []              # fuel weight
        self.W_empty = []             # empty weight
        self.WS_land = []
        self.WS_TO = []
        self.TW_land = []
        self.TW_TO = []
        self.C_LD = []
        self.iteration_num = 0        # num of iterations
        self.master_dict = {}         # master dictionary for data

        # Run parser
        parseData.parseContour(self)

        # Plot Data
        ''' 
        # use for 2
        parseData.plotColor(self, self.f_l, self.AR, self.MRW, 'Fuselage Length [in]', 'Aspect Ratio', 'MRW [lb]')
        parseData.plotColor(self, self.f_l, self.AR, self.W_empty, 'Fuselage Length [in]', 'Aspect Ratio', 'Empty W [lb]')
        parseData.plotColor(self, self.f_l, self.AR, self.W_fuel, 'Fuselage Length [in]', 'Aspect Ratio', 'Fuel W [lb]')
        parseData.plotColor(self, self.f_l, self.AR, self.BFL, 'Fuselage Length [in]', 'Aspect Ratio', 'BFL [ft]')
        plt.show()
        '''
        '''
        # use for 3
        parseData.plotColor(self, self.S, self.AR, self.MRW, 'Reference Area $[m^2]$', 'Aspect Ratio', 'MRW [lb]')
        parseData.plotColor(self, self.S, self.AR, self.W_empty, 'Reference Area $[m^2]$', 'Aspect Ratio', 'Empty W [lb]', True, self.BFL, 9000, 0)
        parseData.plotColor(self, self.S, self.AR, self.W_fuel, 'Reference Area $[m^2]$', 'Aspect Ratio', 'Fuel W [lb]')
        parseData.plotColor(self, self.S, self.AR, self.BFL, 'Reference Area $[m^2]$', 'Aspect Ratio', 'BFL [ft]')
        plt.show()
        '''
        parseData.plotConstriant(self)
        plt.show()


    # Parse data from the contour CSV files, save to lists
    def parseContour(self):
        with open(self.filename, 'rt') as file:
            lines = file.readlines()
            t = []
            for line in lines[1:]:
                l = []
                for ele in line.replace('/n', '').split(',')[1:]:
                    l.append(float(ele.replace('\n', '')))
                t.append(l)
            iterations = len(t[0])
            for i in np.arange(0, iterations):
                self.R.append(t[0][i])
                self.BFL.append(t[1][i])
                #self.f_l.append(t[2][i])
                self.S.append(t[2][i])
                self.AR.append(t[3][i])
                self.FN.append(t[4][i])
                self.W_fuel.append(t[5][i])
                self.W_empty.append(t[6][i])
                self.MRW.append(t[7][i])
                self.WS_land.append(t[8][i])
                self.WS_TO.append(t[9][i])
                self.TW_land.append(t[10][i])
                self.TW_TO.append(t[11][i])
                self.C_LD.append(t[12][i])

    # Take argument of x, y, z lists and make a contour color plot of the xy vs z
    def plotColor(self, x_axis, y_axis, z_axis, x_label, y_label, z_label, filter=False, val=None, vmax=0, vmin=0):
        color_plot = plt.figure(figsize=(9, 7))
        color_plot.subplots_adjust(hspace=.18, left=.12, right=.97, top=.97, bottom=.09)
        color_plot.tight_layout()
        cplot = color_plot.add_subplot(1, 1, 1)
        cplot.set_xlabel(x_label, fontsize=18)
        cplot.set_ylabel(y_label, fontsize=18)
        cplot.tick_params(axis='both', which='major', labelsize=16)
        cplot.tick_params(axis='both', which='minor', labelsize=16)
        x_unique = list(Counter(x_axis).keys())
        y_unique = list(Counter(y_axis).keys())
        x = np.linspace(min(x_unique), max(x_unique), len(x_unique))
        y = np.linspace(min(y_unique), max(y_unique), len(y_unique))
        X, Y = np.meshgrid(x, y)
        Z = np.zeros([len(Y[:, 0].tolist()), len(X[0].tolist())])
        # Create dictionary of pairs
        point_dict = {}
        for i in range(len(x_axis)):
            x_val = x_axis[i]
            y_val = y_axis[i]
            z_val = z_axis[i]
            point_dict[str((x_val, y_val))] = z_val
        for i in range(len(x_unique)):
            for j in range(len(y_unique)):
                x_val = x_unique[i]
                y_val = y_unique[j]
                z_val = point_dict[str((x_val, y_val))]
                Z[j][i] = z_val
        cont = cplot.contourf(X, Y, Z, cmap='coolwarm')
        cbar = color_plot.colorbar(cont)
        cbar.set_label(z_label, fontsize=18)
        cbar.formatter.set_scientific(True)
        cbar.formatter.set_powerlimits((0, 0))
        cbar.ax.tick_params(labelsize=16)
        cbar.ax.yaxis.get_offset_text().set_fontsize(16)
        cbar.update_ticks()
        color_plot.savefig(os.path.join(os.getcwd(), f'plots\\{os.path.basename(self.filename).split("_")[0]}_{z_label.split()[0]}_{x_label.split()[0]}_{y_label.split()[0]}'))
        plt.draw()

    def plotConstriant(self):
        constraint_plot = plt.figure(figsize=(9, 7))
        constraint_plot.subplots_adjust(hspace=.18, left=.12, right=.97, top=.97, bottom=.09)
        constraint_plot.tight_layout()
        conplot = constraint_plot.add_subplot(1, 1, 1)
        conplot.set_xlabel('W/S [psf]', fontsize=18)
        conplot.set_ylabel('T/W [lb/lb]', fontsize=18)
        conplot.set_xlim([0, 700])
        conplot.set_ylim([0, 1.5])
        conplot.grid(linewidth=.5, linestyle='--', color='grey')
        #conplot.tick_params(axis='both', which='major', labelsize=16)
        #conplot.tick_params(axis='both', which='minor', labelsize=16)
        color = ['r', 'y', 'g', 'b', 'k', 'grey', 'orange', 'pink']
        ind = 0
        print()
        for i in range(8):
            if i == 0:
                conplot.plot(self.WS_TO[1:9], self.TW_TO[1:9], c='b', linestyle='--', marker='P', linewidth=1, label='Const. L/D, AR-S iterations')
            else:
                conplot.plot(self.WS_TO[i*9:i*9+9], self.TW_TO[i*9:i*9+9], c='b', linestyle='--', marker='P', linewidth=1)
            ind += 1
        x_r = []
        y_r = []
        x_b = []
        y_b = []
        x_r_0 = 75
        y_r_0 = .25
        x_b_0 = 150
        x1 = np.linspace(x_r_0, 600, num=64)
        y1 = np.linspace(y_r_0, 1.2, num=64)
        x2 = x_b_0*np.ones(64)
        y2 = y1
        for i in np.linspace(0, 500, num=64):
            x_r.append(i + x_r_0)
            y_r.append(i*.002 + y_r_0)
            x_b.append(x_b_0)
            y_b.append(i*.002 + y_r_0)
        conplot.plot(x1, y1, 'r', marker='o', markersize=2.5, linewidth=.5, label='Takeoff')
        conplot.plot(x2, y2, 'k', marker='o', markersize=2.5, linewidth=.5, label='Landing')
        conplot.fill_between(x1, 0, y1, alpha=0.2, facecolor='r')
        conplot.fill_betweenx(y2, x1[-1], x2, alpha=0.2, facecolor='k')
        conplot.legend(loc='upper left', fontsize=12)
        constraint_plot.savefig(os.path.join(os.getcwd(), f'plots\\{os.path.basename(self.filename).split("_")[0]}_Constraint'))




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

    parse = parseData()






