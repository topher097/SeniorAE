"""
Analyze the data from lab 2 - pitch test stand
Plot necessary plots
"""

import numpy as np
import pandas as pd
from sympy import *
import matplotlib.pyplot as plt
import os

curr_dir = os.getcwd()
init_printing(use_unicode=True)

class dataParse():
    # Initialise variables
    def __init__(self, file_input):
        self.imu_rates = []
        self.fileGS = file_input

        # Ground Station data
        self.parsedGS = {}
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
        self.m_p = []
        self.m_r = []
        self.m_y = []

        # Simulation data
        self.parsedSim = {}

    # Parse the data from the CSV file
    def parseGroundStation(self):
        # Load CSV file into a DataFrame
        self.parsedGS = pd.DataFrame(pd.read_csv(self.fileGS,
                                               delimiter=',',
                                               na_values='.',
                                               header=0,
                                               names=['time (s)', 'gyro_x (rad/s)', 'gyro_y (rad/s)', 'gyro_z (rad/s)',
                                                      'imu_pitch (rad)', 'imu_roll (rad)', 'imu_yaw (rad)', 'counter',
                                                    'x (m)', 'y (m)', 'z (m)', 'yaw (rad)',	'pitch (rad)', 'roll (rad)']
                                               ))
        # Save data to class lists
        self.time = self.parsedGS['time (s)'].tolist()
        self.gyro_x = self.parsedGS['gyro_x (rad/s)'].tolist()
        self.gyro_y = self.parsedGS['gyro_y (rad/s)'].tolist()
        self.gyro_z = self.parsedGS['gyro_y (rad/s)'].tolist()
        self.imu_pitch = self.parsedGS['imu_pitch (rad)'].tolist()
        self.imu_roll = self.parsedGS['imu_roll (rad)'].tolist()
        self.imu_yaw = self.parsedGS['imu_yaw (rad)'].tolist()
        self.counter_list = self.parsedGS['counter'].tolist()
        self.x = self.parsedGS['x (m)'].tolist()
        self.y = self.parsedGS['y (m)'].tolist()
        self.z = self.parsedGS['z (m)'].tolist()
        self.mocap_pitch = self.parsedGS['pitch (rad)'].tolist()
        self.mocap_roll = self.parsedGS['roll (rad)'].tolist()
        self.mocap_yaw = self.parsedGS['yaw (rad)'].tolist()

    #
    def parseSimuation(self):
        self.parsedSim = pd.DataFrame(pd.read_csv(self.fileGS,
                                               delimiter=',',
                                               na_values='.',
                                               header=0,
                                               names=['time (s)', 'gyro_x (rad/s)', 'gyro_y (rad/s)', 'gyro_z (rad/s)',
                                                      'imu_pitch (rad)', 'imu_roll (rad)', 'imu_yaw (rad)', 'counter',
                                                      'x (m)', 'y (m)', 'z (m)', 'yaw (rad)', 'pitch (rad)', 'roll (rad)']
                                               ))


    def filterGroundStation(self):
        # Flip flop pitch and roll values for mocap
        self.mocap_pitch = [i * -1 for i in self.mocap_pitch]
        self.mocap_roll = [i * -1 for i in self.mocap_roll]

        # Determine which yaw to plot (find which offset to use)
        err = 0
        for i in range(0, 20):
            err += self.imu_yaw[i] - self.mocap_yaw[i]
        error = int(round((err / 20) / np.pi))
        self.mocap_yaw = [1 * (i + error * np.pi) for i in self.mocap_yaw]

        # Find the offset of the pitch plots
        err = 0
        for i in range(200, 500):
            err += self.imu_pitch[i] - self.mocap_pitch[i]
        pitch_offset = round(err / 300, 3)
        self.m_p = [(i + pitch_offset) for i in self.mocap_pitch]

        # Find the offset of the roll plots
        err = 0
        for i in range(200, 500):
            err += self.imu_roll[i] - self.mocap_roll[i]
        roll_offset = round(err / 300, 3)
        self.m_r = [(i + roll_offset) for i in self.mocap_roll]

        # Find the offset of the yaw plots
        err = 0
        for i in range(200, 500):
            err += self.imu_yaw[i] - self.mocap_yaw[i]
        yaw_offset = round(err / 300, 3)
        self.m_y = [(i + yaw_offset) for i in self.mocap_yaw]
        

class dataPlot:
