import matplotlib.pyplot as plt
from statistics import mean
import os
import csv

class LabOnePartA():
    def __init__(self):
        self.in_file = 'FlightTime.csv'
        self.out_file = 'Output.txt'

        self.data_dict = {}
        self.data_parse = []
        self.airlines = []
        self.dates = []
        self.num_good_data = 0
        self.num_all_data = 0
        self.d = 1741.16        # miles
        self.l_ori = -87.90     # degrees
        self.l_des = -118.41    # degrees
        self.num_data = 0
        self.target_flight_time = 0.117 * self.d + 0.517 * (self.l_ori - self.l_des) + 20   # minutes

        LabOnePartA.parseData(self)
        LabOnePartA.sortData(self)
        LabOnePartA.analyzeData(self)
        LabOnePartA.plotData(self)
        LabOnePartA.writeData(self)

    def parseData(self):
        with open(self.in_file, 'r') as file:
            reader = csv.reader(file)
            self.data_parse = list(reader)
            self.num_all_data = len(self.data_parse)-1

    # Go through the parsed data and sort into a dictionary to read later
    def sortData(self):
        for line in self.data_parse[1:]:
            date = line[0]
            airline = line[1]
            flight_num = int(line[2])
            origin = line[3]
            destination = line[4]
            depart_time = line[5]
            depart_delay = line[6]
            arrival_time = line[7]
            arrival_delay = line[8]
            flight_time = line[9]

            # Check if there are any empty data in line:
            check = [date, airline, flight_num, origin, destination, depart_time, depart_delay, arrival_time, arrival_delay, flight_time]
            full_data = True
            for i in check:
                if i == '':
                    full_data = False
                    break

            good_data = True
            if int(flight_time) < 230:
                good_data = False

            # If there is full/good data, calculate and write to the data dictionary
            if full_data and good_data:
                self.num_good_data += 1
                if airline not in self.airlines:
                    self.data_dict[airline] = {}
                    self.airlines.append(airline)
                if date not in self.dates:
                    self.dates.append(date)
                if date not in self.data_dict[airline].keys():
                    self.data_dict[airline][date] = {}
                if flight_num not in self.data_dict[airline][date].keys():
                    self.data_dict[airline][date][flight_num] = {'origin': origin,
                                                                 'destination': destination,
                                                                 'depart_time': int(depart_time),
                                                                 'depart_delay': int(depart_delay),
                                                                 'arrival_time': int(arrival_time),
                                                                 'arrival_delay': int(arrival_delay),
                                                                 'flight_time': int(flight_time)}

    # Analyze the date stored in data_dict for plotting
    # Calculate: Flight Time, Average Flight Time per airline, Target Flight Time by distance, and Typical Flight Time
    def analyzeData(self):
        for airline in self.airlines:
            total_flight_time = []
            total_flights = 0
            total_delay_time = []
            typical_flight_time_total = []
            for date in self.data_dict[airline].keys():
                for flight_num in self.data_dict[airline][date].keys():
                    total_flights += 1

                    arrival_time = self.data_dict[airline][date][flight_num]['arrival_time']
                    arrival_delay = self.data_dict[airline][date][flight_num]['arrival_delay']
                    depart_time = self.data_dict[airline][date][flight_num]['depart_time']
                    depart_delay = self.data_dict[airline][date][flight_num]['depart_delay']
                    flight_time = self.data_dict[airline][date][flight_num]['flight_time']
                    total_time = (arrival_time + arrival_delay) - (depart_time + depart_delay)
                    total_time = flight_time + arrival_delay + depart_delay

                    total_flight_time.append(total_time)
                    total_delay_time.append(arrival_delay + depart_delay)

            typical_flight_time = mean(total_delay_time) + self.target_flight_time
            time_added = mean(total_flight_time) - typical_flight_time
            self.data_dict[airline]['typical_time'] = typical_flight_time
            self.data_dict[airline]['time_added'] = time_added
            typical_flight_time_total.append(typical_flight_time)

        lowest_time_added_airline = ''
        lowest_time_added = 0
        for airline in self.airlines:
            time_added = self.data_dict[airline]['time_added']
            if lowest_time_added == 0 or time_added < lowest_time_added:
                lowest_time_added = time_added
                lowest_time_added_airline = airline
        self.data_dict['lowest_time_added'] = {'airline': lowest_time_added_airline, 'time_added': lowest_time_added}
        self.data_dict['typical_flight_time_total'] = mean(typical_flight_time_total)
        #print(lowest_time_added_airline, lowest_time_added)

    # Plot the data
    def plotData(self):
        lab_plot = plt.figure(figsize=[8, 8])
        p1 = lab_plot.add_subplot(1, 1, 1)
        for airline in self.airlines:
            time_added = self.data_dict[airline]['time_added']
            p1.bar(airline, time_added, color='b')
        p1.set_xlabel('Airline')
        p1.set_ylabel('Time Added (minutes)')
        p1.set_title('Time Added to Route by Airlines')
        lab_plot.savefig('lab01_plot')
        plt.draw()

    # Write the data to a text file
    def writeData(self):
        text = ''
        text += f'Number of Valid Flights = {self.num_good_data}\n\n'
        text += f'Target Flight Time = {round(self.target_flight_time, 2)} minutes\n\n'
        text += f'Typical Time for Route = {round(self.data_dict["typical_flight_time_total"], 2)} minutes\n\n'
        text += f'Time each Airline Adds to Route:\n'
        for airline in self.airlines:
            text += f'{airline}: {round(self.data_dict[airline]["time_added"], 2)} minutes\n'
        text += '\n'
        text += f'Lowest Flight Time Added: \n{self.data_dict["lowest_time_added"]["airline"]} added {round(self.data_dict["lowest_time_added"]["time_added"], 2)} minutes'
        # Write the text string to a txt file
        with open(self.out_file, 'w+') as f:
            f.write(text)
        print(text)


class LabOnePartB():
    def __init__(self):
        pass


if __name__ == '__main__':
    lab1A = LabOnePartA()
    #lab1B = LabOnePartB()
    plt.show()
