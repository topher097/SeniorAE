import numpy as np
import matplotlib.pyplot as plt
import os
import shutil
from math import sqrt, cos


class homeworkFour():
    def __init__(self):
        self.cp_min_i = -0.6
        self.gamma = 1.4
        self.m_crit_plot = np.linspace(0.22, .99, 2000)

        # Run sections
        homeworkFour.sectionA(self)
        homeworkFour.sectionB(self)
        plt.show()

    # Section A
    def sectionA(self):
        # Calculate the arrays for plotting
        cp_crit_1, cp_crit_2 = [], []
        for i in self.m_crit_plot:
            cp_crit_1.append((2/(self.gamma*i**2))*(((1+(self.gamma-1)/2)/(1+((self.gamma-1)/2)*i**2))**(self.gamma*(1-self.gamma)) - 1))
            cp_crit_2.append(self.cp_min_i/(sqrt(1 - i**2)))

        # Find intersection point
        index = np.argwhere(np.diff(np.sign(np.array(cp_crit_2) - np.array(cp_crit_1)))).flatten()[0]
        m_crit = self.m_crit_plot[index]
        cp_crit = (cp_crit_1[index] + cp_crit_2[index])/2
        m_text = '$M_{crit}$'
        c_text = '$C_{p_{crit}}$'
        info_text = f'{m_text} = {round(m_crit, 5)}\n' \
                    f'{c_text} = {round(cp_crit, 5)}'
        print(f'M_crit_a = {round(m_crit, 5)}')
        print(f'Cp_crit_a = {round(cp_crit, 5)}')

        # Plot the curves and intersection point
        props = dict(boxstyle='round', facecolor='white', alpha=0.25)
        plot_a = plt.figure(figsize=(8, 6))
        cm = plot_a.add_subplot(1, 1, 1)
        cm.set_xlabel('$M_{crit}$', fontsize=16)
        cm.set_ylabel('$C_{p_{crit}}$', fontsize=16)
        cm.set_title('$C_{p_{crit}}$ vs. $M_{crit}$ for problem 2A', fontsize=16)
        cm.grid(linewidth=0.5, color='gray', linestyle='--')
        cm.plot(self.m_crit_plot, cp_crit_1, linestyle='--', color='k', label='Incompressible')
        cm.plot(self.m_crit_plot, cp_crit_2, color='k', label='Compressible')
        cm.scatter(m_crit, cp_crit, edgecolor='k', facecolor='none', marker='o', s=30, label='Loc. of $M_{crit}$')
        cm.text(0.02, 0.26, info_text, transform=cm.transAxes, fontsize=11, verticalalignment='top', bbox=props)
        cm.legend(loc='lower left', fontsize=9)
        plot_a.savefig(os.path.join(os.getcwd(), r'plots\prob2A'))
        plt.draw()

    # Section B
    def sectionB(self):
        # Calc the normal Cp
        self.cp_min_i = self.cp_min_i/(cos(np.deg2rad(25))**2)
        # Calculate the arrays for plotting
        cp_crit_1, cp_crit_2 = [], []
        for i in self.m_crit_plot:
            cp_crit_1.append((2 / (self.gamma * i ** 2)) * (
                        ((1 + (self.gamma - 1) / 2) / (1 + ((self.gamma - 1) / 2) * i ** 2)) ** (
                            self.gamma * (1 - self.gamma)) - 1))
            cp_crit_2.append(self.cp_min_i / (sqrt(1 - i ** 2)))

        # Find intersection point
        index = np.argwhere(np.diff(np.sign(np.array(cp_crit_2) - np.array(cp_crit_1)))).flatten()[0]
        m_crit = self.m_crit_plot[index]
        cp_crit = (cp_crit_1[index] + cp_crit_2[index]) / 2
        m_text = '$M_{crit}$'
        c_text = '$C_{p_{crit}}$'
        info_text = f'{m_text} = {round(m_crit, 5)}\n' \
                    f'{c_text} = {round(cp_crit, 5)}'
        print(f'M_crit_b = {round(m_crit, 5)}')
        print(f'Cp_crit_b = {round(cp_crit, 5)}')

        # Plot the curves and intersection point
        props = dict(boxstyle='round', facecolor='white', alpha=0.25)
        plot_b = plt.figure(figsize=(8, 6))
        cm = plot_b.add_subplot(1, 1, 1)
        cm.set_xlabel('$M_{crit}$', fontsize=16)
        cm.set_ylabel('$C_{p_{crit}}$', fontsize=16)
        cm.set_title('$C_{p_{crit}}$ vs. $M_{crit}$ for problem 2B', fontsize=16)
        cm.grid(linewidth=0.5, color='gray', linestyle='--')
        cm.plot(self.m_crit_plot, cp_crit_1, linestyle='--', color='k', label='Incompressible')
        cm.plot(self.m_crit_plot, cp_crit_2, color='k', label='Compressible')
        cm.scatter(m_crit, cp_crit, edgecolor='k', facecolor='none', marker='o', s=30, label='Loc. of $M_{crit}$')
        cm.text(0.02, 0.26, info_text, transform=cm.transAxes, fontsize=11, verticalalignment='top', bbox=props)
        cm.legend(loc='lower left', fontsize=9)
        plot_b.savefig(os.path.join(os.getcwd(), r'plots\prob2B'))
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

    homeworkFour()