import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as tick
import os
from collections import Counter
import shutil

# Parse the data from excel optimization file (take relative data only)
class parseData():
    def __init__(self):
        self.filename = os.path.join(os.getcwd(), r'Data\747_parse2.csv')
        self.R = []
        self.BFL = []
        self.MRW = []                 # max ramp weight
        self.AR = []                  # aspect ratio
        self.S = []                   # reference area
        self.FN = []                  # total thrust
        self.W_fuel = []              # fuel weight
        self.W_empty = []             # empty weight
        self.iteration_num = 0        # num of iterations
        self.master_dict = {}         # master dictionary for data

        # Run parser
        parseData.parse(self)

        # Plot Data
        parseData.plotColor(self, self.AR, self.S, self.MRW, 'Aspect Ratio', 'Reference Area $[m^2]$', 'MRW [lb]')
        parseData.plotColor(self, self.AR, self.S, self.W_empty, 'Aspect Ratio', 'Reference Area $[m^2]$', 'Empty W [lb]')
        parseData.plotColor(self, self.AR, self.S, self.W_fuel, 'Aspect Ratio', 'Reference Area $[m^2]$', 'Fuel W [lb]')
        parseData.plotColor(self, self.AR, self.S, self.FN, 'Aspect Ratio', 'Reference Area $[m^2]$', 'FN [lb]')
        parseData.plotColor(self, self.AR, self.S, self.BFL, 'Aspect Ratio', 'Reference Area $[m^2]$', 'BFL [ft]')
        plt.show()

    def parse(self):
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
                self.S.append(t[2][i])
                self.AR.append(t[3][i])
                self.FN.append(t[4][i])
                self.W_fuel.append(t[5][i])
                self.W_empty.append(t[6][i])
                self.MRW.append(t[7][i])

    def plotColor(self, x_axis, y_axis, z_axis, x_label, y_label, z_label):
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
        #ax1 = color_plot.add_axes([.92, 0.07, 0.02, 0.9])
        cbar = color_plot.colorbar(cont)
        cbar.set_label(z_label, fontsize=18)
        cbar.formatter.set_scientific(True)
        cbar.formatter.set_powerlimits((0, 0))
        cbar.ax.tick_params(labelsize=16)
        cbar.ax.yaxis.get_offset_text().set_fontsize(16)

        cbar.update_ticks()

        color_plot.savefig(os.path.join(os.getcwd(), f'plots\\{os.path.basename(self.filename).split("_")[0]}_{z_label.split()[0]}_{x_label.split()[0]}_{y_label.split()[0]}'))
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






