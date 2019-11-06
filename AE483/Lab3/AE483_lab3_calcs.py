"""
- Get flight data, parse
- Compute sum squared error per time step
- Compute mean and standard deviation of the sum squared error

"""

import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


# Class to parse data from specific files, store to lists for analysis or plotting
class dataParse():
    # Initialise class variables
    def __init__(self, params):
        self.file_inputs = params['file inputs']        # Files to parse, in list
        self.plot_time = params['plot time']            # Time to plot
        self.gs_file = self.file_inputs[0]              # file path of ground station data
        self.sim_file = self.file_inputs[1]             # file path of simulation data

        # Ground Station data
        self.parsedGS = {}             # Database for ground station parsing
        self.gs_time_cut = 0           # Time to cut plot (gs)
        self.gs_time = []              # Ground Station time
        self.gyro_x = []               # gyro x position
        self.gyro_y = []               # gyro y position
        self.gyro_z = []               # gyro z position
        self.imu_pitch = []            # IMU pitch angle (rad)
        self.imu_roll = []             # IMU roll angle (rad)
        self.imu_yaw = []              # IMU yaw angle (rad)
        self.yaw_des = []              # desired yaw angle (rad)
        self.pitch_des = []            # desired pitch angle (rad)
        self.roll_des = []             # desired angle angle (rad)
        self.counter_list = []         # counter list from ground station
        self.x = []                    # mocap x position
        self.y = []                    # mocap y position
        self.z = []                    # mocap z position
        self.x_des = []                # mocap desired x position
        self.y_des = []                # mocap desired y position
        self.z_des = []                # mocap desired z position
        self.mocap_pitch = []          # raw mocap pitch
        self.mocap_roll = []           # raw mocap roll
        self.mocap_yaw = []            # raw mocap yaw
        self.mocap_pitch_offset = 0    # mocap pitch data offset
        self.mocap_roll_offset = 0     # mocap roll data offset
        self.mocap_yaw_offset = 0      # mocap yaw data offset
        self.mocap_pitch_filter = []   # filtered mocap pitch
        self.mocap_roll_filter = []    # filtered mocap roll
        self.mocap_yaw_filter = []     # filtered mocap yaw
        self.mu1 = []                  # Motor command 1
        self.mu2 = []                  # motor command 2
        self.mu3 = []                  # motor command 3
        self.mu4 = []                  # motor command 4
        self.offset_gs = params['time_offset']  # offset the real data by a certain time (s)

        # Simulation data
        self.parsedSim = {}
        self.sim_time = []             # Simulation time
        self.sim_time_cut = 0          # Set time to cut plot (sim)
        self.sim_x_des = []            # Simulation x position desire
        self.sim_y_des = []            # Simulation y position desire
        self.sim_z_des = []            # Simulation z position desire
        self.sim_x = []                # Simulation x position
        self.sim_y = []                # Simulation y position
        self.sim_z = []                # Simulation z position
        self.sim_pitch = []            # Simulation measured pitch
        self.sim_yaw = []              # Simulation measured yaw
        self.sim_roll = []             # Simulation measured roll

        # Run parser and filter
        self.parseGroundStation()       # parse ground station data
        self.parseSimuation()          # parse simulation data
        #self.filterGroundStation()      # filter ground station data

    # Parse the data from the CSV file from the ground station
    def parseGroundStation(self):
        # Load CSV file into a DataFrame
        self.parsedGS = pd.DataFrame(pd.read_csv(self.gs_file,
                                                      delimiter=',',
                                                      na_values='.',
                                                      header=0,
                                                      names=['time (s)', ' accel_x (m/s^2)', ' accel_y (m/s^2)',
                                                             'accel_z (m/s^2)', 'gyro_x (rad/s)', 'gyro_y (rad/s)',
                                                             'gyro_z (rad/s)', 'x (m)', 'y (m)', 'z (m)',
                                                             'yaw (rad)', 'pitch (rad)', 'roll (rad)',
                                                             'mocap_counter', 'counter',
                                                             'desired x', 'desired y', 'desired z', 'desired yaw']
                                                      ))

        # Save data to class lists
        self.gs_time = self.parsedGS['time (s)'].tolist()

        # Determine where to cut data to shift the time
        offset_cut_location = 0
        if not self.offset_gs == 0:
            for time in self.gs_time:
                if time - self.offset_gs >= 0:
                    offset_cut_location = self.gs_time.index(time) - 1
                    break

        self.gs_time = [i - self.offset_gs for i in self.gs_time[offset_cut_location::]]
        self.gyro_x = self.parsedGS['gyro_x (rad/s)'].tolist()[offset_cut_location::]
        self.gyro_y = self.parsedGS['gyro_y (rad/s)'].tolist()[offset_cut_location::]
        self.gyro_z = self.parsedGS['gyro_y (rad/s)'].tolist()[offset_cut_location::]
        #self.imu_pitch = self.parsedGS['imu_pitch (rad)'].tolist()[offset_cut_location::]
        #self.imu_roll = self.parsedGS['imu_roll (rad)'].tolist()[offset_cut_location::]
        #self.imu_yaw = self.parsedGS['imu_yaw (rad)'].tolist()[offset_cut_location::]
        self.counter_list = self.parsedGS['mocap_counter'].tolist()[offset_cut_location::]
        self.x = self.parsedGS['x (m)'].tolist()[offset_cut_location::]
        self.y = self.parsedGS['y (m)'].tolist()[offset_cut_location::]
        self.z = self.parsedGS['z (m)'].tolist()[offset_cut_location::]
        self.mocap_pitch = self.parsedGS['pitch (rad)'].tolist()[offset_cut_location::]
        self.mocap_roll = self.parsedGS['roll (rad)'].tolist()[offset_cut_location::]
        self.mocap_yaw = self.parsedGS['yaw (rad)'].tolist()[offset_cut_location::]
        #self.mu1 = self.parsedGS['mu1'].tolist()[offset_cut_location::]
        #self.mu2 = self.parsedGS['mu2'].tolist()[offset_cut_location::]
        self.x_des = self.parsedGS['desired x'].tolist()[offset_cut_location::]
        self.y_des = self.parsedGS['desired y'].tolist()[offset_cut_location::]
        self.z_des = self.parsedGS['desired z'].tolist()[offset_cut_location::]
        self.yaw_des = self.parsedGS['desired yaw'].tolist()[offset_cut_location::]
        #self.pitch_des = self.parsedGS['desired pitch'].tolist()[offset_cut_location::]
        #self.roll_des = self.parsedGS['desired roll'].tolist()[offset_cut_location::]

        # Find the time where t=plot_time (for plotting)
        if self.gs_time[-1] < self.plot_time:
            self.gs_time_cut = self.gs_time[-1]
        else:
            for time in self.gs_time:
                if time - self.plot_time >= 0:
                    self.gs_time_cut = time
                    break

    # Parse the data from the CSV file from the simulation
    def parseSimuation(self):
        self.parsedSim = pd.DataFrame(pd.read_csv(self.sim_file,
                                                       delimiter=',',
                                                       na_values='.',
                                                       names=['time (s)', 'x_desired (m)', 'y_desired (m)', 'z_desired (m)',
                                                              'x (m)', 'y (m)', 'z (m)',
                                                              'yaw (rad)', 'pitch (rad)', 'roll (rad)']
                                                       ))

        # Save data to class lists
        self.sim_time = self.parsedSim['time (s)'].tolist()
        self.sim_x_des = self.parsedSim['x_desired (m)'].tolist()
        self.sim_y_des = self.parsedSim['y_desired (m)'].tolist()
        self.sim_z_des = self.parsedSim['z_desired (m)'].tolist()
        self.sim_x = self.parsedSim['x (m)'].tolist()
        self.sim_y = self.parsedSim['y (m)'].tolist()
        self.sim_z = self.parsedSim['z (m)'].tolist()
        self.sim_pitch = self.parsedSim['pitch (rad)'].tolist()
        self.sim_yaw = self.parsedSim['yaw (rad)'].tolist()
        self.sim_roll = self.parsedSim['roll (rad)'].tolist()

        # Find the time list where t=plot_time (for plotting)
        if self.sim_time[-1] < self.plot_time:
            self.sim_time_cut = self.sim_time[-1]
        else:
            for time in self.sim_time:
                if time - self.plot_time >= 0:
                    self.sim_time_cut = time
                    break

    # Filter the mocap data, save to new lists
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
        self.mocap_pitch_offset = round(err / 300, 3)
        self.mocap_pitch_filter = [(i + self.mocap_pitch_offset) for i in self.mocap_pitch]

        # Find the offset of the roll plots
        err = 0
        for i in range(200, 500):
            err += self.imu_roll[i] - self.mocap_roll[i]
        self.mocap_roll_offset = round(err / 300, 3)
        self.mocap_roll_filter = [(i + self.mocap_roll_offset) for i in self.mocap_roll]

        # Find the offset of the yaw plots
        err = 0
        for i in range(200, 500):
            err += self.imu_yaw[i] - self.mocap_yaw[i]
        self.mocap_yaw_offset = round(err / 300, 3)
        self.mocap_yaw_filter = [(i + self.mocap_yaw_offset) for i in self.mocap_yaw]


# Complete calculations specific to lab 3
class labThree():

    # Initialize variables
    def __init__(self, params):
        self.sum_squared_error = []
        self.position_error_x = []
        self.position_error_y = []
        self.position_error_z = []
        self.position_error_x_sim = []
        self.position_error_y_sim = []
        self.position_error_z_sim = []
        self.mean_deviation = 0
        self.std_deviation = 0
        self.mean = 0
        self.N = 0

        self.x = parse.x
        self.y = parse.y
        self.z = parse.z
        self.x_des = parse.x_des
        self.y_des = parse.y_des
        self.z_des = parse.z_des

        self.x_sim = parse.sim_x
        self.y_sim = parse.sim_y
        self.z_sim = parse.sim_z
        self.x_des_sim = parse.sim_x_des
        self.y_des_sim = parse.sim_y_des
        self.z_des_sim = parse.sim_z_des

        self.flight = params['flight']

        # Run the calculations
        labThree.calcSumSquaredError(self)
        labThree.calcDeviation(self)
        labThree.calcPositionError(self)

    # Calculate the sum squared error of mocap position and desired position
    def calcSumSquaredError(self):
        for index in range(0, len(self.x)):
            x = self.x[index]
            y = self.y[index]
            z = self.z[index]
            x_des = self.x_des[index]
            y_des = self.y_des[index]
            z_des = self.z_des[index]
            error = (x - x_des)**2 + (y - y_des)**2 + (z - z_des)**2    # Calc mean squared error
            self.sum_squared_error.append(error)

    # Calculate mean, standard deviation
    def calcDeviation(self):
        self.N = len(self.sum_squared_error)                    # Get length of data set
        self.mean = sum(self.sum_squared_error)/self.N          # Calculate mean of the mean square error
        self.std_deviation = np.std(self.sum_squared_error)     # Calculate the standard deviation of mean square error
        print(f'Standard Deviation for {self.flight} = {self.std_deviation}')

    # Calculate positional error
    def calcPositionError(self):
        # Mocap data
        for index in range(0, len(self.x)):
            x = self.x[index]
            y = self.y[index]
            z = self.z[index]
            x_des = self.x_des[index]
            y_des = self.y_des[index]
            z_des = self.z_des[index]
            error_x = x - x_des           # Calc pos error x
            error_y = y - y_des           # Calc pos error y
            error_z = z - z_des           # Calc pos error z
            self.position_error_x.append(error_x)
            self.position_error_y.append(error_y)
            self.position_error_z.append(error_z)

        # Simulation data
        for index in range(0, len(self.x_sim)):
            x = self.x_sim[index]
            y = self.y_sim[index]
            z = self.z_sim[index]
            x_des = self.x_des_sim[index]
            y_des = self.y_des_sim[index]
            z_des = self.z_des_sim[index]
            error_x = x - x_des  # Calc pos error x
            error_y = y - y_des  # Calc pos error y
            error_z = z - z_des  # Calc pos error z
            self.position_error_x_sim.append(error_x)
            self.position_error_y_sim.append(error_y)
            self.position_error_z_sim.append(error_z)


# Plot the data
class plotData():
    # Initialize variables
    def __init__(self, params):
        self.flight = params['flight']
        self.plot_bool = params['plot_bool']

        # Setting up mocap position plot
        self.mocap_pos_plot = plt.figure(figsize=(12, 6))
        self.mocap_pos_plot.subplots_adjust(hspace=.35)
        self.mocap_pos_plot.tight_layout()

        # Setting up mean squared error plot
        self.mse_plot = plt.figure(figsize=(12, 5))
        self.mse_plot.subplots_adjust(hspace=.5)
        self.mse_plot.tight_layout()

        # Setting up position error plot
        self.perror = plt.figure(figsize=(12, 5))
        self.perror.subplots_adjust(hspace=.35)
        self.perror.tight_layout()

        # Setting up angle plot
        self.angles = plt.figure(figsize=(12, 4.5))
        self.angles.subplots_adjust(hspace=.5)
        self.angles.tight_layout()

        # Plot
        plotData.plotMSE(self)
        plotData.plotPositionError(self)
        plotData.plotMocapPos(self)
        plotData.plotAngles(self)

        # Save and display
        plotData.savePlots(self)
        plt.draw()

    # Plot the Mean Squared Error over time plot (histogram)
    def plotMSE(self):
        mse = self.mse_plot.add_subplot(1, 1, 1)
        props = dict(boxstyle='round', facecolor='white', alpha=0.5)
        error_text = f'Standard Deviation = {round(lab3.std_deviation, 5)}'
        #mse.set_title(f'Frequency of Mean Squared Error - {self.flight}')
        mse.set_ylabel('Frequency', fontdict={'fontsize': 13})
        mse.set_xlabel('Mean Squared Error', fontdict={'fontsize': 13})
        mse.text(0.7, 0.95, error_text, transform=mse.transAxes, fontsize=11, verticalalignment='top', bbox=props)
        mse.hist(lab3.sum_squared_error, bins=45, density=True, rwidth=.9)

    # Plot the position error over time
    def plotPositionError(self):
        time = parse.gs_time
        time_end = time.index(parse.gs_time_cut)
        time_sim = parse.sim_time
        time_sim_end = time_sim.index(parse.sim_time_cut)

        # Plot x position error
        perror_x = self.perror.add_subplot(3, 1, 1)
        #perror_x.set_title(f'Position Error X vs Time - {self.flight}')
        #perror_x.set_xlabel('Time [s]', fontdict={'fontsize': 18})
        perror_x.set_ylabel('X Pos. Error [m]', fontdict={'fontsize': 11})
        perror_x.plot(time[:time_end], np.zeros(len(lab3.position_error_x[:time_end])), color='grey', linestyle='--')
        perror_x.plot(time_sim[:time_sim_end], lab3.position_error_x_sim[:time_sim_end], 'y', label='sim error')
        perror_x.plot(time[:time_end], lab3.position_error_x[:time_end], 'b', label='real error')
        perror_x.legend(loc='upper right', fontsize=12)

        # Plot y position error
        perror_y = self.perror.add_subplot(3, 1, 2)
        #perror_y.set_title(f'Position Error Y vs Time - {self.flight}')
        #perror_y.set_xlabel('Time [s]')
        perror_y.set_ylabel('Y Pos. Error [m]', fontdict={'fontsize': 11})
        perror_y.plot(time[:time_end], np.zeros(len(lab3.position_error_y[:time_end])), color='grey', linestyle='--')
        perror_y.plot(time_sim[:time_sim_end], lab3.position_error_y_sim[:time_sim_end], 'y', label='sim error')
        perror_y.plot(time[:time_end], lab3.position_error_y[:time_end], 'b', label='real error')
        perror_y.legend(loc='upper right', fontsize=12)

        # Plot z position error
        perror_z = self.perror.add_subplot(3, 1, 3)
        #perror_z.set_title(f'Position Error Z vs Time - {self.flight}')
        perror_z.set_xlabel('Time [s]', fontdict={'fontsize': 11})
        perror_z.set_ylabel('Z Pos. Error [m]', fontdict={'fontsize': 11})
        perror_z.plot(time[:time_end], np.zeros(len(lab3.position_error_z[:time_end])), color='grey', linestyle='--')
        perror_z.plot(time_sim[:time_sim_end], lab3.position_error_z_sim[:time_sim_end], 'y', label='sim error')
        perror_z.plot(time[:time_end], lab3.position_error_z[:time_end], 'b', label='real error')
        perror_z.legend(loc='upper right', fontsize=12)

    # Plot the mocap position and the desired position
    def plotMocapPos(self):
        time = parse.gs_time
        time_end = time.index(parse.gs_time_cut)
        time_sim = parse.sim_time
        time_sim_end = time_sim.index(parse.sim_time_cut)

        # Plot x
        mp_x = self.mocap_pos_plot.add_subplot(3, 1, 1)
        #mp_x.set_title(f'X Position vs Time - {self.flight}')
        #mp_x.set_xlabel('Time [s]')
        mp_x.set_ylabel('X Pos. [m]', fontdict={'fontsize': 11})
        mp_x.plot(time[:time_end], np.zeros(len(parse.x[:time_end])), color='grey', linestyle='--')
        mp_x.plot(time[:time_end], parse.x_des[:time_end], 'b', label='x desired position')
        mp_x.plot(time[:time_end], parse.x[:time_end], 'r', label='x position')
        mp_x.plot(time_sim[:time_sim_end], lab3.x_sim[:time_sim_end], 'y', label='x sim position')
        mp_x.legend(loc='upper right', fontsize=12)

        # Plot y
        mp_y = self.mocap_pos_plot.add_subplot(3, 1, 2)
        #mp_y.set_title(f'Y Position vs Time - {self.flight}')
        #mp_y.set_xlabel('Time [s]')
        mp_y.set_ylabel('Y Pos. [m]', fontdict={'fontsize': 11})
        mp_y.plot(time[:time_end], np.zeros(len(parse.y[:time_end])), color='grey', linestyle='--')
        mp_y.plot(time[:time_end], parse.y_des[:time_end], 'b', label='y desired position')
        mp_y.plot(time[:time_end], parse.y[:time_end], 'r', label='y position')
        mp_y.plot(time_sim[:time_sim_end], lab3.y_sim[:time_sim_end], 'y', label='y sim position')
        mp_y.legend(loc='upper right', fontsize=12)

        # Plot z
        mp_z = self.mocap_pos_plot.add_subplot(3, 1, 3)
        #mp_z.set_title(f'Z Position vs Time - {self.flight}')
        mp_z.set_xlabel('Time [s]', fontdict={'fontsize': 11})
        mp_z.set_ylabel('Z Pos. [m]', fontdict={'fontsize': 11})
        mp_z.plot(time[:time_end], np.zeros(len(parse.z[:time_end])), color='grey', linestyle='--')
        mp_z.plot(time[:time_end], parse.z_des[:time_end], 'b', label='z desired position')
        mp_z.plot(time[:time_end], parse.z[:time_end], 'r', label='z position')
        mp_z.plot(time_sim[:time_sim_end], lab3.z_sim[:time_sim_end], 'y', label='z sim position')
        mp_z.legend(loc='upper right', fontsize=12)

    # Plot the mocap angle and desired angles over time
    def plotAngles(self):
        time = parse.gs_time
        time_end = time.index(parse.gs_time_cut)
        time_sim = parse.sim_time
        time_sim_end = time_sim.index(parse.sim_time_cut)

        # Plot yaw
        a_yaw = self.angles.add_subplot(1, 1, 1)
        #a_yaw.set_title(f'Yaw Angle vs Time - {self.flight}')
        a_yaw.set_xlabel('Time [s]', fontdict={'fontsize': 13})
        a_yaw.set_ylabel('Yaw Angle [rad]', fontdict={'fontsize': 13})
        a_yaw.plot(time[:time_end], parse.yaw_des[:time_end], 'b', label='yaw desired')
        a_yaw.plot(time[:time_end], parse.mocap_yaw[:time_end], 'r', label='mocap yaw')
        a_yaw.plot(time_sim[:time_sim_end], parse.sim_yaw[:time_sim_end], 'y', label='sim yaw')
        a_yaw.legend(loc='upper right', fontsize=12)

    def savePlots(self):
        self.mocap_pos_plot.savefig(os.path.join(os.getcwd(), f'plots\\mocap_position_{self.flight}.png'))
        self.mse_plot.savefig(os.path.join(os.getcwd(), f'plots\\mean_square_error_{self.flight}.png'))
        self.perror.savefig(os.path.join(os.getcwd(), f'plots\\position_error_{self.flight}.png'))
        self.angles.savefig(os.path.join(os.getcwd(), f'plots\\angles_{self.flight}.png'))


if __name__ == '__main__':
    # Get the filenames to parse, calc, and plot
    data_location = os.path.join(os.getcwd() + r'\Lab3_Data2')
    # Final flightplan is a copy of IDK.csv
    filenames = [['final_flightplan.csv', 'simulation_flightplan.csv'], ['final_hover.csv', 'simulation_hover.csv']]
    flight = ['standard_flightpath', 'hover']
    times = [95, 15]
    time_offsets = [0, 2.35]
    plot_bool = [True, True]
    files = []
    for file_pair in filenames:
        files.append([os.path.join(data_location, i) for i in file_pair])
    params = {}

    # Initialize classes, let them run
    for flight_type in range(0, len(flight)):
        params['plot time'] = times[flight_type]  # Time in seconds of which to plot the data
        params['file inputs'] = files[flight_type]  # file inputs
        params['flight'] = flight[flight_type]
        params['time_offset'] = time_offsets[flight_type]
        params['plot_bool'] = plot_bool[flight_type]
        parse = dataParse(params)
        lab3 = labThree(params)
        if plot_bool[flight_type]:
            plot = plotData(params)
        plt.show()
