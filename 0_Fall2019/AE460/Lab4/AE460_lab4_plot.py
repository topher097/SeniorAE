import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
import os
import numpy as np
from scipy.interpolate import interpolate
import scipy


class plotData:
    
    def __init__(self, filename):
        self.filename = filename
        self.parsed_data = {}
        self.f1 = []
        self.f2 = []
        self.f3 = []
        self.f4 = []
        self.vp = []

        self.x = []
        self.f1_error = []
        self.f2_error = []
        self.f3_error = []
        self.f4_error = []

    # Parse the data from the CSV file from the simulation
    def parseData(self):
        self.parsed_data = pd.DataFrame(pd.read_csv(self.filename,
                                                       delimiter=',',
                                                       na_values='.',
                                                       header=0,
                                                       names=['stag. pressure (Pa)', 'M#1 Thrust (N)', 'M#2a Thrust (N)',
                                                              'M#2b Thrust (N)', 'M#2c Thrust (N)']
                                                       ))

        # Save data to class lists
        self.vp = self.parsed_data['stag. pressure (Pa)'].tolist()
        self.f1 = self.parsed_data['M#1 Thrust (N)'].tolist()
        self.f2 = self.parsed_data['M#2a Thrust (N)'].tolist()
        self.f3 = self.parsed_data['M#2b Thrust (N)'].tolist()
        self.f4 = self.parsed_data['M#2c Thrust (N)'].tolist()

    # Calc error
    def errorCalc(self):

        for i in range(0, len(self.vp)):
            self.f2_error.append(abs(((self.f2[i] - self.f1[i])/self.f1[i]) * 100))
            self.f3_error.append(abs(((self.f3[i] - self.f1[i])/self.f1[i]) * 100))
            self.f4_error.append(abs(((self.f4[i] - self.f1[i])/self.f1[i]) * 100))

    # Plot data
    def plotData(self):
        #plt.rcParams.update({'font.size': 18})

        force_plot = plt.figure(figsize=(10, 8))
        force_plot.subplots_adjust(hspace=1.1)
        a1 = force_plot.add_subplot(1, 1, 1)
        title_name = 'Force vs Stagnation Pressure (truncated)'

        a1.set_title(title_name, fontsize=18)
        a1.set_xlabel('Stagnation Pressure (Pa)', fontsize=18)
        a1.set_ylabel('Force [N]', fontsize=18)
        a1.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.2E'))
        a1.plot(self.vp, self.f1, '--k', label='Method #1')
        a1.scatter(self.vp, self.f1, s=50, facecolors='none', edgecolors='k')
        #a1.plot(self.vp, self.f2, '--b', label='Method #2a')
        #a1.scatter(self.vp, self.f2, s=50, facecolors='none', edgecolors='b')
        a1.plot(self.vp[:-3], self.f2[:-3], '--b', label='Method #2a')
        a1.scatter(self.vp[:-3], self.f2[:-3], s=50, facecolors='none', edgecolors='b')
        a1.plot(self.vp, self.f3, '--g', label='Method #2b')
        a1.scatter(self.vp, self.f3, s=50, facecolors='none', edgecolors='g')
        a1.plot(self.vp, self.f4, '--r', label='Method #2c')
        a1.scatter(self.vp, self.f4, s=50, facecolors='none', edgecolors='r')
        a1.legend(loc='upper left', fontsize=14)
        plt.draw()

        error_plot = plt.figure(figsize=(10, 8))
        error_plot.subplots_adjust(hspace=1.1)
        a2 = error_plot.add_subplot(1, 1, 1)
        title_name = 'Percent Error wrt Method #1 vs. Stagnation Pressure'

        a2.set_title(title_name, fontsize=18)
        a2.set_xlabel('Stagnation Pressure (Pa)', fontsize=18)
        a2.set_ylabel('Percent Error [%]', fontsize=18)
        a2.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.2E'))
        a2.plot(self.vp, np.zeros(len(self.vp)), color='k')
        a2.plot(self.vp, self.f2_error, '--b', label='Method #2a')
        a2.scatter(self.vp, self.f2_error, s=50, facecolors='none', edgecolors='b')
        a2.plot(self.vp, self.f3_error, '--g', label='Method #2b')
        a2.scatter(self.vp, self.f3_error, s=50, facecolors='none', edgecolors='g')
        a2.plot(self.vp, self.f4_error, '--r', label='Method #2c')
        a2.scatter(self.vp, self.f4_error, s=50, facecolors='none', edgecolors='r')
        a2.legend(loc='upper left', fontsize=14)
        plt.show()


if __name__ == '__main__':
    lab4 = plotData(filename=os.getcwd() + r'\force_data.csv')
    lab4.parseData()
    lab4.errorCalc()
    lab4.plotData()
