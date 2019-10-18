import sympy
import numpy as np
import os
import matplotlib.pyplot as plt

class homeworkOne:

    def __init__(self):
        self.filename = os.getcwd() + r'/BL_hw1.dat'
        self.parsed = {}
        self.xc = []
        self.cfx = []
        self.Ue = []
        self.H = []
        self.x_tr = 0
        self.cfx_tr = 0
        self.Rec = 3 * 10**6
        self.th = []
        self.dth = []

    # Parse the data from the dat file
    def parse(self):
        # Load file and sort data into lists
        with open(self.filename, 'rt') as dat_file:
            lines = dat_file.readlines()[1:]
            for line in lines:
                data = line.replace('\n', '').split('\t')
                data = [float(i) for i in data]

                # Save data to class lists
                self.xc.append(data[0])
                self.cfx.append(data[1])
                self.Ue.append(data[2])
                self.H.append(data[3])

    # Find the chord location where the transition occurs
    def transitionOccur(self):
        for i in range(20, len(self.xc)):
            if self.cfx[i-1] < self.cfx[i]:
                self.x_tr = self.xc[i+1]
                self.cfx_tr = self.cfx[i+1]
                break
        plt.figure()
        plt.plot(self.xc, self.cfx, label='Cfx')
        plt.scatter(self.x_tr, self.cfx_tr, color='r', label='Transition Point')
        plt.title('$C_{f_x}$ vs. $\\frac{x}{c}$', fontsize=18)
        plt.xlabel('$\\frac{x}{c}$', fontsize=18)
        plt.ylabel('$C_{f_x}$', fontsize=18)
        plt.draw()

    # Calc dimensionless momentum thickness (corrected)
    def momThick(self):
        dUe = np.diff(self.Ue)/np.diff(self.xc)
        dx = np.diff(self.xc)
        N = len(self.xc)
        self.dth = [0*i for i in range(0, N-1)]
        self.th = [0*i for i in range(0, N)]
        self.th[0] = 0

        for i in range(1, N-1):
            self.dth[i] = self.cfx[i]/2 - self.th[i]/self.Ue[i] * (self.H[i]+2)*dUe[i]
            self.th[i+1] = self.th[i] + self.dth[i]*dx[i]

        plt.figure()
        plt.plot(self.xc, self.th, label='mom_thick')
        plt.title('$\\frac{\\theta}{c}$ vs. $\\frac{x}{c}$', fontsize=18)
        plt.xlabel('$\\frac{x}{c}$', fontsize=18)
        plt.ylabel('$\\frac{\\theta}{c}$', fontsize=18)
        plt.draw()

    # Using Squire-young formula to calculate drag coeffcient
    def dragCoef(self):
        # Multiply the theta/c from before
        Cd = 2 * 2*self.th[-1] * self.Ue[-1]**((5 + self.H[-1])/2)
        print(f'Drag Coefficient (Cd) = {Cd}')


if __name__ == '__main__':
    hw = homeworkOne()
    hw.parse()
    hw.transitionOccur()
    hw.momThick()
    hw.dragCoef()
    plt.show()

