from sympy import *
import numpy as np
from AE483.Lab1.AE483_lab1_report import dataCalculations


class rotationMatrixCalc:
    def __init__(self):
        self.data = dataCalculations.parse(self)

    def rotationCalc(self):
        # Calculate the rotation matrix for the mocap values
        t_y = Symbol('t_yaw')
        t_p = Symbol('t_pitch')
        t_r = Symbol('t_roll')

        R_0onyaw = np.array([[cos(t_y), -sin(t_y), 0],
                             [sin(t_y), cos(t_y), 0],
                             [0, 0, 1]])
        R_yawonpitch = np.array([[cos(t_p), 0, sin(t_p)],
                                 [0, 1, 0],
                                 [-sin(t_p), 0, sin(t_p)]])
        R_pitchon1 = np.array([[1, 0, 0],
                               [0, cos(t_r), -sin(t_r)],
                               [0, sin(t_r), cos(t_r)]])
        self.R_1on0 = np.ndarray.tolist(np.linalg.multi_dot([R_0onyaw, R_yawonpitch, R_pitchon1]))

        # Transform the mocap to the drone frame with R0on1
        for i in range(0, len(self.time)):
            mocap_angles = Matrix([self.mocap_yaw[i], self.mocap_pitch[i], self.mocap_roll[i]])
            R_0on1 = Matrix(self.R_1on0).subs([(t_y, mocap_angles[0]), (t_p, mocap_angles[1]), (t_r, mocap_angles[2])])
            new_mocap_angles = R_0on1 @ mocap_angles
            self.new_mocap_yaw.append(new_mocap_angles[0])
            self.new_mocap_pitch.append(new_mocap_angles[1])
            self.new_mocap_roll.append(new_mocap_angles[2])
