
'''
Q1: Find the rate at which the onboard code runs
1. Import data, parse into lists
2. Sum the counter variable for 100 data points (we set our data rate to 1 Hz
3. Average the board run rate over full flight time to get solution

Q2:
'''


import scipy.interpolate
import numpy as np
import pandas as pd
from sympy import *
init_printing(use_unicode=True)

filenames = [r'C:\Users\TOPHER-LAPTOP\Desktop\SeniorAE\AE483\Lab 1\flying.csv']


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

    def parse(self):
        self.parsed = pd.DataFrame(pd.read_csv(self.file,
                                               delimiter=',',
                                               na_values='.',
                                               header=0,
                                               names=['time (s)', 'gyro_x (rad/s)', 'gyro_y (rad/s)', 'gyro_z (rad/s)',
                                                      'imu_pitch (rad)', 'imu_roll (rad)', 'imu_yaw (rad)', 'counter',
                                                    'x (m)', 'y (m)', 'z (m)', 'yaw (rad)',	'pitch (rad)', 'roll (rad)']
                                               ))
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
        total_counter = 0
        total_time = float(self.time[-1]) - float(self.time[0])

        # Get counter data for averaging
        for i in range(0, len(self.time)):
            total_counter += int(counter[i])
        # Average
        self.run_rate = total_counter/total_time


    # Calculate the IMU and MOCAP agreeability
    def calcAgree(self):
        # Calculate the rotation matrix for the mocap values
        t_y = Symbol('t_yaw')
        t_p = Symbol('t_pitch')
        t_r = Symbol('t_roll')

        R_0onyaw = np.array([[cos(t_y), -sin(t_y), 0],
                             [sin(t_y), cos(t_y), 0],
                             [0, 0, 1]])
        R_yawonpitch = np.array([[cos(t_p), 0, cos(t_p)],
                                 [0, 1, 0],
                                 [-sin(t_p), 0, sin(t_p)]])
        R_pitchon1 = np.array([[1, 0, 0],
                               [0, cos(t_r), -sin(t_r)],
                               [0, sin(t_r), cos(t_r)]])


        self.R_1on0 = np.ndarray.tolist(np.linalg.multi_dot([R_0onyaw, R_yawonpitch, R_pitchon1]))
        print(self.R_1on0)
        print(Matrix(self.R_1on0))
        # Transform the mocap to the drone frame with R0on1
        for i in range(0, len(self.time)):
            mocap_angles = Matrix[[self.mocap_yaw[i]], [self.mocap_pitch[i]], [self.mocap_roll[i]]]
            R0on1 = Matrix(self.R_1on0).subs([(t_y, mocap_yaw), (t_p, mocap_pitch), (t_r, mocap_roll)])
            new_mocap_angles = mocap_angles @ R0on1
            new_mocap_yaw = new_mocap_angles[0]
            new_mocap_pitch = new_mocap_angles[1]
            new_mocap_roll = new_mocap_angles[2]



if __name__ == '__main__':
    for filename in filenames:
        obj = dataCalculations(filename)
        # Parse the data
        obj.parse()
        # Calc onboard run rate
        #obj.calcRun()
        #print(f'On-board run rate = {round(obj.run_rate/1000, 2)} kHz')
        # Calculate the agreeability in IMU and MOCAP yaw, pitch, and roll
        obj.calcAgree()
        print(f'Agreeability: \nYaw = {obj.agr_yaw} rad\nPitch = {obj.agr_pitch} rad\nRoll = {obj.agr_roll} rad\n')

