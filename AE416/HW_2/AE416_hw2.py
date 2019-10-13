import sympy
from sympy import *
import numpy as np
import matplotlib.pyplot as plt

# Homework 2, Problem 1
class problemOne:
    """
    (35%) A flat plate is placed in a free stream flow, developing a Blasius boundary layer.
    The plate has a length of 1.5 ft and the free stream velocity is 25 ft/sec. Assume standard,
    sea-level conditions, and that the boundary layer over the flat plate is laminar across the
    entire length. Suppose you wish to approximate the boundary layer profile with:
    a)  Determine the displacement thickness (δ*) and momentum thickness (θ) at the end
        of the plate, using the previous polynomial.
    b)  For a Blasius boundary layer, we can also obtain solutions for δ* and θ using:
        -   θ = 0.664x/sqrt(Re_x)
        -   δ* = 1.721x/sqrt(Re_x)
        -   Determine δ* and θ using these relations and compare these values to the
            polynomial approximation from part a.
    """

    # Initialize variables
    def __init__(self):
        self.length = 0.4572        # m, 1.50 feet
        self.free_vel = 7.62        # m, 25.0 ft/sec
        self.rho = 1.225            # kg/m^3
        self.pressure = 101332      # Pa
        self.temp = 288.15          # K
        self.theta = 0              # Momentum Thickness
        self.delta = 0              # Displacement thickness
        self.re = 0                 # Reynolds number
        self.dynamic_visc = 0       # Dynamic viscosity of air, kg/m-s
        self.b = 1.458*10**-6       # kg/(m s K^.5)
        self.S = 110.4              # K
        self.disp_thick = []        # displacement thickness
        self.mom_thick = []         # momentum thickness
        self.bl_thick = 0           # boundary layer thickness

        self.disp_thick_list_poly = []
        self.disp_thick_list_blasius = []
        self.mom_thick_list_poly = []
        self.mom_thick_list_blasius = []
        self.bl_thick_list = []
        self.diff_disp_thick = []
        self.diff_mom_thick = []
        self.diff_disp_avg = 0
        self.diff_mom_avg = 0
        self.x = np.linspace(0, self.length, 100)

    # Calculate parameters
    def paramCalc(self):
        # Dynamic viscosity using Sutherland Eq
        self.dynamic_visc = (self.b * self.temp ** (3 / 2)) / (self.temp + self.S)      # kg/m-s

        # Reynolds number at x = l
        self.re = (self.rho * self.free_vel * self.length) / self.dynamic_visc

        # Boundary layer thickness at x = l (laminar)
        self.bl_thick = (4.91 * self.length) / sqrt(self.re)        # m


    # Problem One
    def secA(self):
        """
        u/U = 2*y/delta - (y/delta)^2
        disp_thick = integral{0}{inf} (1- u/U) dy
        mom_thick = integral{0}{inf} u/U * (1- u/U) dy
        """
        # Create symbol for integration
        y = sympy.Symbol('y')
        # Displacement Thickness Calculation
        for i in self.x:
            re = (self.rho * self.free_vel * i) / self.dynamic_visc
            bl_thick = (5 * i) / sqrt(re)
            vel = 2 * (y / bl_thick) - (y / bl_thick) ** 2
            disp_thick = sympy.integrate(1 - vel, (y, 0, bl_thick))
            mom_thick = sympy.integrate(vel * (1 - vel), (y, 0, bl_thick))

            self.disp_thick_list_poly.append(disp_thick)
            self.mom_thick_list_poly.append(mom_thick)
            self.bl_thick_list.append(bl_thick)

    # Problem Two
    def secB(self):
        """
        θ = 0.664x/sqrt(Re_x)
        δ* = 1.721x/sqrt(Re_x)
        """

        # Displacement Thickness Calculation
        for i in self.x:
            re = (self.rho * self.free_vel * i) / self.dynamic_visc
            disp_thick = 1.721 * i / sqrt(re)
            mom_thick = 0.664 * i / sqrt(re)

            self.disp_thick_list_blasius.append(disp_thick)
            self.mom_thick_list_blasius.append(mom_thick)

    # Calculate
    def differenceCalc(self):
        for i in range(1, len(self.x)):
            self.diff_disp_thick.append(abs(self.disp_thick_list_poly[i] - self.disp_thick_list_blasius[i]))
            self.diff_mom_thick.append(abs(self.mom_thick_list_poly[i] - self.mom_thick_list_blasius[i]))
        for i in range(0, len(self.diff_disp_thick)):
            self.diff_disp_avg += self.diff_disp_thick[i]
            self.diff_mom_avg += self.diff_mom_thick[i]
        self.diff_disp_avg = self.diff_disp_avg/len(self.diff_disp_thick)
        self.diff_mom_avg = self.diff_mom_avg/len(self.diff_mom_thick)

    # Plot data
    def plotData(self):
        mom_poly_text = r'\Theta_{polynomial_{x=l}}'
        disp_poly_text = r'\delta^{*}_{polynomial_{x=l}}'
        mom_blasius_text = r'\Theta_{Blasius_{x=l}}'
        disp_blasius_text = r'\delta^{*}_{Blasius_{x=l}}'
        disp_dif_text = r'\Delta\Theta'
        mom_dif_text = r'\Delta\delta^{*}'
        avg_disp_dif_text = r'\overline{\Delta\Theta}'
        avg_mom_dif_text = r'\overline{\Delta\delta^{*}}'
        bl_text = r'\delta_{x=l}'

        plot_info_text_1 = f'{"${}$".format(disp_poly_text)} = {round(self.disp_thick_list_poly[-1], 7)} [m] \n' + \
                           f'{"${}$".format(mom_poly_text)} = {round(self.mom_thick_list_poly[-1], 7)} [m] \n' + \
                           f'{"${}$".format(disp_blasius_text)} = {round(self.disp_thick_list_blasius[-1], 7)} [m] \n' + \
                           f'{"${}$".format(mom_blasius_text)} = {round(self.mom_thick_list_blasius[-1], 7)} [m] \n' + \
                           f'{"${}$".format(bl_text)} = {round(self.bl_thick, 7)} [m]'

        plot_info_text_2 = f'{"${}$".format(avg_disp_dif_text)} = {round(self.diff_disp_avg, 7)} [m] \n' + \
                           f'{"${}$".format(avg_mom_dif_text)} = {round(self.diff_mom_avg, 8)} [m]'

        props = dict(boxstyle='round', facecolor='white', alpha=0.5)

        # Plot
        disp_plot = plt.figure(figsize=(12, 9))
        disp_plot.subplots_adjust(hspace=.25)

        a1 = disp_plot.add_subplot(2, 1, 1)
        a1.set_title('Thickness vs x')
        a1.set_xlabel('x [m]')
        a1.set_ylabel('Thickness [m]')
        a1.plot(self.x, self.disp_thick_list_poly, 'r', label='Displacement thickness (polynomial)', linewidth=1)
        a1.plot(self.x, self.mom_thick_list_poly, 'b', label='Momentum thickness (polynomial)', linewidth=1)
        a1.scatter(self.x[0::3], self.disp_thick_list_blasius[0::3], marker='.', color='y', label='Displacement thickness (Blasius)', linewidth=0.5)
        a1.scatter(self.x[0::3], self.mom_thick_list_blasius[0::3], marker='.', color='g', label='Momentum thickness (Blasius)', linewidth=0.5)
        a1.plot(self.x, self.bl_thick_list, 'k', label='Boundary layer thickness', linewidth=1)
        a1.text(0.05, 0.95, plot_info_text_1, transform=a1.transAxes, fontsize=11, verticalalignment='top', bbox=props)
        a1.legend(loc='upper right')

        a2 = disp_plot.add_subplot(2, 1, 2)
        a2.set_title('Different in Thickness vs x')
        a2.set_xlabel('x [m]')
        a2.set_ylabel('Thickness [m]')
        a2.plot(self.x[1:], self.diff_disp_thick, 'r', label=f'{"${}$".format(disp_dif_text)}', linewidth=1)
        a2.plot(self.x[1:], self.diff_mom_thick, 'b', label=f'{"${}$".format(mom_dif_text)}', linewidth=1)
        a2.text(0.05, 0.95, plot_info_text_2, transform=a2.transAxes, fontsize=11, verticalalignment='top', bbox=props)
        a2.legend(loc='upper right')
        plt.show()

# Homework 2, Problem 3
class problemThree:
    """
    (50%) You are an engineer in charge of the horizontal tail design of a general aviation
    aircraft. In order to set the tail incidence you must first determine the apparent angle of
    attack seen by the tail. Since the wing upstream of the tail is producing lift, you realize
    that there will be a relative downwash created by the circulation produced by the wing.
    a)  Given the geometry of the horseshoe vortex (below), show that the downwash
        velocity along the aircraft centerline can be expressed (in terms of Γ, l, and d) as:
            - w = rho/pi*l ( (l/4ad) + (d/a) + 1), where a = sqrt((l/d)^2 + d^2)
    b)  Assume that your aircraft is similar to a Piper Cherokee. Using the data provided,
        estimate the flow inclination angle, θ, between the freestream flow direction and
        the direction of flow at the tail under cruise conditions at an altitude of 10,000 ft.
        Ignore the circulation effects at the tail and assume a single horseshoe vortex.
        (Hint: L = lρV∞Γ)
            - Weight (W) = 2400 lb
            - Flight Velocity (V∞) = 100 mph
            - Wing span (b) = 30 ft
            - Effective span (l) = 0.85b
            - Distance from wing c/4 to LE of HSTAB (d) = 12.65 ft
    """
    # Initialize parameters
    def __init__(self):
        self.a = 0                  #
        self.w = 0                  #
        self.circulation = 0
        self.l = 0
        self.d = 0
        self.v_inf = 0
        self.weight = 0

    # Calculate parameters
    def paramCalc(self):
        self.a = sqrt((self.l/2)**2 + self.d**2)

    # Section B
    def secB(self):
        pass


if __name__ == '__main__':
    hw2_1 = problemOne()        # Homework 2, Problem 1
    hw2_1.paramCalc()           # Calculate parameters
    hw2_1.secA()                # Run section A
    hw2_1.secB()                # Run section B
    hw2_1.differenceCalc()      # Calculate Difference
    hw2_1.plotData()            # Plot data

    hw2_3 = problemThree()      # Homework 2, Problem 3
    hw2_3.paramCalc()           # Calculate parameters
    hw2_3.secB()                # Run section B
