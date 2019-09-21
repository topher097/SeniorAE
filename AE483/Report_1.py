""""
AE483 - AB2 (FA19)
Report 1 data analysis for question 1, 2, and 3

Q1: Find the rate at which the on-board code runs

Q2: Find the agreeability of the IMU and mocap data

Q3: Is the gyro measuring angular rates or angular velocities
"""

import numpy as np
import pandas as pd
from sympy import *
import matplotlib.pyplot as plt
import os

curr_dir = os.getcwd()
init_printing(use_unicode=True)

filenames = [str(curr_dir) + i for i in [r'\Lab 1\flying.csv', r'\Lab 1\hand.csv']]


# Get the data, make sure the data is in the correct format
class dataCalculations:
    # Initialise variables
    def __init__(self, file_input):
        self.imu_rates = []
        self.file = file_input
        self.parsed = {}
        self.time = []
        self.gyro_x = []
        self.gyro_y = []
        self.gyro_z = []
        self.imu_pitch = []
        self.imu_roll = []
        self.imu_yaw = []
        self.counter_list = []
        self.x = []
        self.y = []
        self.z = []
        self.mocap_pitch = []
        self.mocap_roll = []
        self.mocap_yaw = []
        self.new_mocap_pitch = []
        self.new_mocap_roll = []
        self.new_mocap_yaw = []

        self.run_rate = 0
        self.R_1on0 = []
        self.agr_yaw = 0
        self.agr_pitch = 0
        self.agr_roll = 0
        self.m_p = []
        self.m_r = []
        self.m_y = []

    # Parse the data from the CSV file
    def parse(self):
        # Load CSV file into a DataFrame
        self.parsed = pd.DataFrame(pd.read_csv(self.file,
                                               delimiter=',',
                                               na_values='.',
                                               header=0,
                                               names=['time (s)', 'gyro_x (rad/s)', 'gyro_y (rad/s)', 'gyro_z (rad/s)',
                                                      'imu_pitch (rad)', 'imu_roll (rad)', 'imu_yaw (rad)', 'counter',
                                                    'x (m)', 'y (m)', 'z (m)', 'yaw (rad)',	'pitch (rad)', 'roll (rad)']
                                               ))
        # Save data to class lists
        self.time = self.parsed['time (s)'].tolist()
        self.gyro_x = self.parsed['gyro_x (rad/s)'].tolist()
        self.gyro_y = self.parsed['gyro_y (rad/s)'].tolist()
        self.gyro_z = self.parsed['gyro_y (rad/s)'].tolist()
        self.imu_pitch = self.parsed['imu_pitch (rad)'].tolist()
        self.imu_roll = self.parsed['imu_roll (rad)'].tolist()
        self.imu_yaw = self.parsed['imu_yaw (rad)'].tolist()
        self.counter_list = self.parsed['counter'].tolist()
        self.x = self.parsed['x (m)'].tolist()
        self.y = self.parsed['y (m)'].tolist()
        self.z = self.parsed['z (m)'].tolist()
        self.mocap_pitch = self.parsed['pitch (rad)'].tolist()
        self.mocap_roll = self.parsed['roll (rad)'].tolist()
        self.mocap_yaw = self.parsed['yaw (rad)'].tolist()

    # Calculate the on-board runtime
    def calcRun(self):
        counter = self.counter_list
        start_counter = counter[0]
        tot_run_rate = 0

        # Get counter data for averaging
        amount = 0
        for i in range(1, len(self.time)):
            tot_run_rate += (int(counter[i]) - start_counter)/(self.time[i] - self.time[0])
            amount += 1

        # Average
        self.run_rate = tot_run_rate/amount

    # Calculate the IMU and MOCAP agreeability (Q2)
    def calcAgree(self):

        # Flip flop pitch and roll values for mocap
        self.mocap_pitch = [i * -1 for i in self.mocap_pitch]
        self.mocap_roll = [i * -1 for i in self.mocap_roll]

        # Determine which yaw to plot (find which offset to use)
        err = 0
        for i in range(0, 20):
            err += self.imu_yaw[i] - self.mocap_yaw[i]
        error = int(round((err/20)/np.pi))
        self.mocap_yaw = [1 * (i + error*np.pi) for i in self.mocap_yaw]

        # Find the offset of the pitch plots
        err = 0
        for i in range(200, 500):
            err += self.imu_pitch[i] - self.mocap_pitch[i]
        pitch_offset = round(err/300, 3)
        self.m_p = [(i + pitch_offset) for i in self.mocap_pitch]

        # Find the offset of the roll plots
        err = 0
        for i in range(200, 500):
            err += self.imu_roll[i] - self.mocap_roll[i]
        roll_offset = round(err/300, 3)
        self.m_r = [(i + roll_offset) for i in self.mocap_roll]

        # Find the offset of the yaw plots
        err = 0
        for i in range(200, 500):
            err += self.imu_yaw[i] - self.mocap_yaw[i]
        yaw_offset = round(err/300, 3)
        self.m_y = [(i + yaw_offset) for i in self.mocap_yaw]

        # Plot pitch, roll, yaw for IMU and mocap
        fig = plt.figure(figsize=(15, 8))
        fig.subplots_adjust(hspace=.5)
        fig.suptitle(f'Data for "{os.path.basename(self.file)}"')

        a1 = fig.add_subplot(311)
        a1.set_title('Pitch Angle over Time')
        a1.set_xlabel('Time (s)')
        a1.set_ylabel('Angle (rad)')
        a1.plot(self.time, self.imu_pitch, 'r', label='imu_pitch')
        a1.plot(self.time, self.m_p, 'b', label=f'mocap_pitch, offset={pitch_offset}rad')
        a1.legend(loc='upper left')

        a2 = fig.add_subplot(312)
        a2.set_title('Roll Angle over Time')
        a2.set_xlabel('Time (s)')
        a2.set_ylabel('Angle (rad)')
        a2.plot(self.time, self.imu_roll, 'y', label='imu_roll')
        a2.plot(self.time, self.m_r, 'g', label=f'mocap_roll, offset={roll_offset}rad')
        a2.legend(loc='upper left')

        a3 = fig.add_subplot(313)
        a3.set_title('Yaw Angle over Time')
        a3.set_xlabel('Time (s)')
        a3.set_ylabel('Angle (rad)')
        a3.plot(self.time, self.imu_yaw, 'k', label='imu_yaw')
        a3.plot(self.time, self.m_y, 'r', label=f'mocap_yaw, offset={yaw_offset}rad')
        a3.legend(loc='upper left')

        #plt.show()

    # Determine if gyro is measuring angular velocity or angular rates (Q3)
    def angVelPlt(self):
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
        angvel_matrix_i = np.linalg.multi_dot([np.matrix.transpose(R_yawonpitch @ R_pitchon1), np.array([[0], [0], [1]])])
        angvel_matrix_j = np.linalg.multi_dot([np.transpose(R_pitchon1), np.array([[0], [1], [0]])])
        angvel_matrix = np.ndarray.tolist(np.array([[np.ndarray.tolist(angvel_matrix_i[0])[0], np.ndarray.tolist(angvel_matrix_j[0])[0], 1],
                                                   [np.ndarray.tolist(angvel_matrix_i[1])[0], np.ndarray.tolist(angvel_matrix_j[1])[0], 0],
                                                   [np.ndarray.tolist(angvel_matrix_i[2])[0], np.ndarray.tolist(angvel_matrix_j[2])[0], 0]]))

        mocap_angvel_pitch = []
        mocap_angvel_yaw = []
        mocap_angvel_roll = []
        mocap_angrate_pitch = []
        mocap_angrate_yaw = []
        mocap_angrate_roll = []

        # Use finite difference method to calculate the angular velocity between each data point
        for i in range(0, len(self.time)-1):
            d_time = self.time[i+1] - self.time[i]
            d_imu_pitch = self.imu_pitch[i+1] - self.imu_pitch[i]
            d_imu_roll = self.imu_roll[i+1] - self.imu_roll[i]
            d_imu_yaw = self.imu_yaw[i+1] - self.imu_yaw[i]
            angrate_pitch = d_imu_pitch/d_time
            angrate_roll = d_imu_roll/d_time
            angrate_yaw = d_imu_yaw/d_time
            mocap_angvel = Matrix([angrate_yaw, angrate_pitch, angrate_roll])

            angvel_matrix_eval = Matrix(angvel_matrix).subs([(t_y, self.imu_yaw[i]), (t_p, self.imu_pitch[i]), (t_r, self.imu_roll[i])])
            mocap_angvel_drone = angvel_matrix_eval @ mocap_angvel

            mocap_angvel_yaw.append(mocap_angvel_drone[0])
            mocap_angvel_pitch.append(mocap_angvel_drone[1])
            mocap_angvel_roll.append(-1 * mocap_angvel_drone[2])
            mocap_angrate_yaw.append(-1 * angrate_yaw)
            mocap_angrate_pitch.append(angrate_pitch)
            mocap_angrate_roll.append(angrate_roll)

        # Plot all the things
        time_plt = self.time[:-1]
        fig2 = plt.figure(figsize=(15, 8))
        fig2.subplots_adjust(hspace=.5)
        fig2.suptitle(f'Data for "{os.path.basename(self.file)}"')

        b1 = fig2.add_subplot(311)
        b1.set_title('Yaw Angular Velocity over Time')
        b1.set_xlabel('Time (s)')
        b1.set_ylabel('Angle Velocity (rad/sec)')
        b1.plot(self.time, self.gyro_z, 'y', linewidth=.5, label='Gyro z')
        b1.plot(time_plt, mocap_angvel_yaw, 'b', linewidth=.5, label='Ang. Velocity')
        b1.plot(time_plt, mocap_angrate_yaw, 'g', linewidth=.5, label='Ang. Rate')
        b1.legend(loc='upper left')

        b2 = fig2.add_subplot(312)
        b2.set_title('Pitch Angular Velocity over Time')
        b2.set_xlabel('Time (s)')
        b2.set_ylabel('Angle Velocity (rad/sec)')
        b2.plot(self.time, self.gyro_y, 'y', linewidth=.5, label='Gyro y')
        b2.plot(time_plt, mocap_angvel_pitch, 'b', linewidth=.5, label='Ang. Velocity')
        b2.plot(time_plt, mocap_angrate_pitch, 'g', linewidth=.5, label='Ang. Rate')
        b2.legend(loc='upper left')

        b3 = fig2.add_subplot(313)
        b3.set_title('Roll Angular Velocity over Time')
        b3.set_xlabel('Time (s)')
        b3.set_ylabel('Angle Velocity (rad/sec)')
        b3.plot(self.time, self.gyro_x, 'y', label='Gyro x', linewidth=.5)
        b3.plot(time_plt, mocap_angvel_roll, 'b', label='Ang. Velocity', linewidth=.5)
        b3.plot(time_plt, mocap_angrate_roll, 'g', label='Ang. Rate', linewidth=.5)
        b3.legend(loc='upper left')

        plt.show()

# Run the script
if __name__ == '__main__':
    for filename in filenames:
        # Initialize class variables
        obj = dataCalculations(filename)
        # Parse the data
        obj.parse()
        # Calc on-board run rate (Q1)
        obj.calcRun()
        print(f'On-board run rate for {os.path.basename(filename)} = {round(obj.run_rate/1000, 2)} kHz')
        # Plot IMU and MOCAP yaw, pitch, and roll (Q2) to show agreeability
        obj.calcAgree()
        obj.angVelPlt()
