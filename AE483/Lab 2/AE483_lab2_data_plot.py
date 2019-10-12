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

# Get list of filenames to run through the parser
data_location = str(curr_dir) + '\\Lab 2 Data\\'
filename_base = ['period', 'Simulation']
commonator = ['_0.5', '_1', '_2', '_3', '_5']
filename_ext = '.csv'
filenames = [(data_location + filename_base[0] + i + filename_ext, data_location + filename_base[1] + i + filename_ext) for i in commonator]


# Class to parse data from specific files, store to lists for analysis or plotting
class dataParse:
    # Initialise variables
    gs_file = ''
    sim_file = ''
    parsedGS = {}
    gs_time = []
    gs_time_cut = 0
    gyro_x = []
    gyro_y = []
    gyro_z = []
    imu_pitch = []
    imu_roll = []
    imu_yaw = []
    counter_list = []
    x = []
    y = []
    z = []
    mocap_pitch = []
    mocap_roll = []
    mocap_yaw = []
    mocap_pitch_offset = 0
    mocap_roll_offset = 0
    mocap_yaw_offser = 0
    mocap_pitch_filter = []
    mocap_roll_filter = []
    mocap_yaw_filter = []
    gs_pitch_desired = []
    mu1 = []
    mu2 = []

    # Simulation data
    parsedSim = {}
    sim_time = []
    sim_time_cut = 0
    sim_pitch_desired = []
    sim_pitch = []
    sim_angvel_pitch = []
    sim_u2 = []

    def __init__(self, file_inputs):
        dataParse.gs_file = file_inputs[0]
        dataParse.sim_file = file_inputs[1]

        # Ground Station data
        dataParse.parsedGS = {}
        dataParse.gs_time = []               # Ground Station time
        dataParse.gyro_x = []
        dataParse.gyro_y = []
        dataParse.gyro_z = []
        dataParse.imu_pitch = []
        dataParse.imu_roll = []
        dataParse.imu_yaw = []
        dataParse.counter_list = []
        dataParse.x = []                     # mocap x
        dataParse.y = []                     # mocap y
        dataParse.z = []                     # mocap z
        dataParse.mocap_pitch = []           # raw mocap pitch
        dataParse.mocap_roll = []            # raw mocap roll
        dataParse.mocap_yaw = []             # raw mocap yaw
        dataParse.mocap_pitch_offset = 0     # mocap pitch data offset
        dataParse.mocap_roll_offset = 0      # mocap roll data offset
        dataParse.mocap_yaw_offser = 0       # mocap yaw data offset
        dataParse.mocap_pitch_filter = []    # filtered mocap pitch
        dataParse.mocap_roll_filter = []     # filtered mocap roll
        dataParse.mocap_yaw_filter = []      # filtered mocap yaw
        dataParse.gs_pitch_desired = []
        dataParse.mu1 = []
        dataParse.mu2 = []

        # Simulation data
        dataParse.parsedSim = {}
        dataParse.sim_time = []              # Simulation time
        dataParse.sim_time_cut = 0
        dataParse.sim_pitch_desired = []     # Simulation pitch desire
        dataParse.sim_pitch = []             # Simulation measured pitch
        dataParse.sim_angvel_pitch = []      # Simulation angular velocity of pitch
        dataParse.sim_u2 = []                # Simulation value of u2

    # Parse the data from the CSV file from the ground station
    def parseGroundStation(self):
        # Load CSV file into a DataFrame
        dataParse.parsedGS = pd.DataFrame(pd.read_csv(dataParse.gs_file,
                                               delimiter=',',
                                               na_values='.',
                                               header=0,
                                               names=['time (s)', 'gyro_x (rad/s)', 'gyro_y (rad/s)', 'gyro_z (rad/s)',
                                                      'imu_pitch (rad)', 'imu_roll (rad)', 'imu_yaw (rad)', 'counter',
                                                    'x (m)', 'y (m)', 'z (m)', 'yaw (rad)',	'pitch (rad)', 'roll (rad)',
                                                    'angle_pitch_desired (rad)', 'mu1', 'mu2']
                                               ))
        # Save data to class lists
        dataParse.gs_time = dataParse.parsedGS['time (s)'].tolist()
        dataParse.gyro_x = dataParse.parsedGS['gyro_x (rad/s)'].tolist()
        dataParse.gyro_y = dataParse.parsedGS['gyro_y (rad/s)'].tolist()
        dataParse.gyro_z = dataParse.parsedGS['gyro_y (rad/s)'].tolist()
        dataParse.imu_pitch = dataParse.parsedGS['imu_pitch (rad)'].tolist()
        dataParse.imu_roll = dataParse.parsedGS['imu_roll (rad)'].tolist()
        dataParse.imu_yaw = dataParse.parsedGS['imu_yaw (rad)'].tolist()
        dataParse.counter_list = dataParse.parsedGS['counter'].tolist()
        dataParse.x = dataParse.parsedGS['x (m)'].tolist()
        dataParse.y = dataParse.parsedGS['y (m)'].tolist()
        dataParse.z = dataParse.parsedGS['z (m)'].tolist()
        dataParse.mocap_pitch = dataParse.parsedGS['pitch (rad)'].tolist()
        dataParse.mocap_roll = dataParse.parsedGS['roll (rad)'].tolist()
        dataParse.mocap_yaw = dataParse.parsedGS['yaw (rad)'].tolist()
        dataParse.gs_pitch_desired = dataParse.parsedGS['angle_pitch_desired (rad)'].tolist()
        dataParse.mu1 = dataParse.parsedGS['mu1'].tolist()
        dataParse.mu2 = dataParse.parsedGS['mu2'].tolist()

        # Find the index of the time list where t=plot_time
        for time in dataParse.gs_time:
            if time - plot_time >= 0:
                dataParse.gs_time_cut = dataParse.gs_time.index(time)
                break



    # Parse the data from the CSV file from the simulation
    def parseSimuation(self):
        dataParse.parsedSim = pd.DataFrame(pd.read_csv(dataParse.sim_file,
                                               delimiter=',',
                                               na_values='.',
                                               header=0,
                                               names=['time', 'pitch_desired', 'ang_pitch', 'angvel_pitch', 'u2']
                                               ))

        # Save data to class lists
        dataParse.sim_time = dataParse.parsedSim['time'].tolist()
        dataParse.sim_pitch_desired = dataParse.parsedSim['pitch_desired'].tolist()
        dataParse.sim_pitch = dataParse.parsedSim['ang_pitch'].tolist()
        dataParse.sim_angvel_pitch = dataParse.parsedSim['angvel_pitch'].tolist()
        dataParse.sim_u2 = dataParse.parsedSim['u2'].tolist()

        # Find the index of the time list where t=plot_time
        for time in dataParse.sim_time:
            if time - plot_time >= 0:
                dataParse.sim_time_cut = dataParse.sim_time.index(time)
                break
        
    # Filter the mocap data, save to new lists
    def filterGroundStation(self):
        # Flip flop pitch and roll values for mocap
        dataParse.mocap_pitch = [i * -1 for i in dataParse.mocap_pitch]
        dataParse.mocap_roll = [i * -1 for i in dataParse.mocap_roll]

        # Determine which yaw to plot (find which offset to use)
        err = 0
        for i in range(0, 20):
            err += dataParse.imu_yaw[i] - dataParse.mocap_yaw[i]
        error = int(round((err / 20) / np.pi))
        dataParse.mocap_yaw = [1 * (i + error * np.pi) for i in dataParse.mocap_yaw]

        # Find the offset of the pitch plots
        err = 0
        for i in range(200, 500):
            err += dataParse.imu_pitch[i] - dataParse.mocap_pitch[i]
        dataParse.mocap_pitch_offset = round(err / 300, 3)
        dataParse.mocap_pitch_filter = [(i + dataParse.mocap_pitch_offset) for i in dataParse.mocap_pitch]

        # Find the offset of the roll plots
        err = 0
        for i in range(200, 500):
            err += dataParse.imu_roll[i] - dataParse.mocap_roll[i]
        dataParse.mocap_roll_offset = round(err / 300, 3)
        dataParse.mocap_roll_filter = [(i + dataParse.mocap_roll_offset) for i in dataParse.mocap_roll]

        # Find the offset of the yaw plots
        err = 0
        for i in range(200, 500):
            err += dataParse.imu_yaw[i] - dataParse.mocap_yaw[i]
        dataParse.mocap_yaw_offset = round(err / 300, 3)
        dataParse.mocap_yaw_filter = [(i + dataParse.mocap_yaw_offset) for i in dataParse.mocap_yaw]
        

# Class to plot the data
class dataPlot(dataParse):
    def __init__(self):
        pass

    # Plot the pitch angle, pitch desired, and simulation pitch
    def plotPitch(self):
        a1 = pitch_plot.add_subplot(len(filenames), 1, index)
        title_name = os.path.basename(dataParse.gs_file).replace('.csv', '').replace('period_', '')
        a1.set_title(f'Data for Period = {title_name} Seconds')
        a1.set_xlabel('Time [s]')
        a1.set_ylabel('Angle [rad]')
        a1.plot(dataParse.gs_time[:dataParse.gs_time_cut], dataParse.imu_pitch[:dataParse.gs_time_cut], 'r', label='imu pitch [rad]')
        a1.plot(dataParse.gs_time[:dataParse.gs_time_cut], dataParse.gs_pitch_desired[:dataParse.gs_time_cut], 'b', label='pitch desired [rad]')
        a1.plot(dataParse.sim_time, dataParse.sim_pitch, 'orange', label='simulation pitch [rad]')
        a1.legend(loc='upper right')


if __name__ == '__main__':
    global index
    global pitch_plot
    global plot_time

    # Define figure for pitch plotting
    plot_time = 6        # Seconds
    pitch_plot = plt.figure(figsize=(15, 8))
    pitch_plot.subplots_adjust(hspace=1)
    #pitch_plot.suptitle('Data for Pitch Angle')
    #pitch_plot.suptitle(f'Data for Period="{os.path.basename(dataParse.sim_file)}"')

    for files in filenames:
        index = filenames.index(files) + 1
        # Parse the data (and filter)
        data = dataParse(files)
        data.parseGroundStation()
        data.parseSimuation()
        data.filterGroundStation()

        # Plot the data
        plotting = dataPlot()
        plotting.plotPitch()
    plt.show()

