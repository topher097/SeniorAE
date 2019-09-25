"""
Author: Christopher Endres
AE416, HW1, 9/25/19
"""
import os
import matplotlib.pyplot as plt

class homeworkOne1:

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
        self.theta_c_array = []
        self.drag_coeff = 0

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
        plt.figure()
        plt.plot(self.xc, self.cfx, label='Cfx', color='b')
        plt.scatter(self.x_tr, self.cfx_tr, color='r', label='Transition Point')
        plt.title('Cfx vs. x/c')
        plt.xlabel('x/c')
        plt.ylabel('Cfx')
        plt.legend()
        plt.draw()

    # Calculate dimensionless momentum thickness (theta/c)
    def momentumThickCalc(self):
        # Integrate through data points to calculate d_theta/d_c
        for i in range(0, len(self.xc)):
            xc = self.xc[i]
            cfx = self.cfx[i]
            u_frac = self.U_frac[i]
            H = self.H[i]
            theta_c = .5*cfx*xc/(u_frac**2 * (H+3))
            self.theta_c_array.append(theta_c)
        plt.figure()
        plt.plot(self.xc, self.theta_c_array, label='theta/c', color='b')
        plt.title('theta/c vs. x/c')
        plt.xlabel('x/c')
        plt.ylabel('theta/c')
        plt.legend()
        plt.draw()

    # Using Squire-Young formula to calculate drag coefficient
    def dragCoefficient(self):
        # Multiply the theta/c from before
        theta_c = 2 * self.theta_c_array[-1]
        U_frac = self.U_frac[-1]
        H = self.H[-1]
        self.drag_coeff = 2 * theta_c * U_frac**((H+5)/2)
        print(self.drag_coeff)


if __name__ == '__main__':
    hw1 = homeworkOne1()
    hw1.parse()
    hw1.transitionOccur()
    hw1.momentumThickCalc()
    hw1.dragCoefficient()
    plt.show()

