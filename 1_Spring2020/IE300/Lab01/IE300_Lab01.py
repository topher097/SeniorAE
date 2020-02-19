import matplotlib.pyplot as plt
import os
import csv

class LabOne():
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

        LabOne.parseData(self)
        LabOne.sortData(self)
        LabOne.analyzeData(self)
        #LabOne.plotData(self)

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

            # If there is full data, calculate and write to the data dictionary
            if full_data:
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
                                                                 'depart_time': depart_time,
                                                                 'depart_delay': depart_delay,
                                                                 'arrival_time': arrival_time,
                                                                 'arrival_delay': arrival_delay,
                                                                 'flight_time': flight_time}

    # Analyze the date stored in data_dict for plotting
    def analyzeData(self):
        for airline in self.airlines:
            for date in self.data_dict[airline].keys():
                flight_nums = list(self.data_dict[airline][date])
                print(airline, date, flight_nums)

    # Plot the data
    def plotData(self):
        lab_plot = plt.figure(figsize=[10, 10])
        p1 = lab_plot.add_subplot(1, 1, 1)
        p1.bar(x, y)




if __name__ == '__main__':
    lab1 = LabOne()
