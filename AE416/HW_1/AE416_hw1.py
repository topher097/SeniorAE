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
        self.U_frac = []
        self.H = []
        self.x_tr = 0
        self.cfx_tr = 0
        self.Rec = 3 * 10**6

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
                self.U_frac.append(data[2])
                self.H.append(data[3])

    # Find the chord location where the transition occurs
    def transitionOccur(self):
        for i in range(20, len(self.xc)):
            if self.cfx[i-1] < self.cfx[i]:
                self.x_tr = self.xc[i+1]
                self.cfx_tr = self.cfx[i+1]
                break
        plt.scatter(self.xc, self.cfx)
        plt.scatter(self.x_tr, self.cfx_tr, color='r')
        plt.show()


if __name__ == '__main__':
    hw = homeworkOne()
    hw.parse()
    hw.transitionOccur()

