import matplotlib.pyplot as plt
from statistics import mean
import numpy as np
import os
import csv

class LabOnePartA():
    def __init__(self):
        self.in_file = 'FlightTime.csv'
        self.out_file_A = 'Output_A.txt'

        self.data_dict = {}
        self.data_parse = []
        self.airlines = []
        self.dates = []
        self.num_good_data = 0
        self.num_all_data = 0
        self.num_data = 0
        self.d = 1741.16        # miles
        self.l_ori = -87.90     # degrees
        self.l_des = -118.41    # degrees
        self.target_flight_time = 0.117 * self.d + 0.517 * (self.l_ori - self.l_des) + 20   # minutes

        # Run the case study part A
        LabOnePartA.parseData(self)
        LabOnePartA.sortData(self)
        LabOnePartA.analyzeData(self)
        LabOnePartA.plotData(self)
        LabOnePartA.writeData(self)

        # Run the case study part B

    # Parse the data from the .csv file and save to a list
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

            # Check if there are any empty data in line
            check = [date, airline, flight_num, origin, destination, depart_time, depart_delay, arrival_time, arrival_delay, flight_time]
            full_data = True
            for i in check:
                if i == '':
                    full_data = False
                    break
            # Check of the flight time is above 230 minutes
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

    # Analyze the data stored in data_dict for plotting
    # Calculate: Flight Time, Average Flight Time per airline, Target Flight Time by distance, and Typical Flight Time
    def analyzeData(self):
        delay_time_total = []
        flight_time_total = []
        time_added_total = []
        for airline in self.airlines:
            total_flight_time = []
            total_flights = 0
            total_delay_time = []
            for date in self.data_dict[airline].keys():
                for flight_num in self.data_dict[airline][date].keys():
                    total_flights += 1
                    arrival_delay = self.data_dict[airline][date][flight_num]['arrival_delay']
                    depart_delay = self.data_dict[airline][date][flight_num]['depart_delay']
                    flight_time = self.data_dict[airline][date][flight_num]['flight_time']
                    total_flight_time.append(flight_time)
                    total_delay_time.append(arrival_delay + depart_delay)
            delay_time_total.append(mean(total_delay_time))
            flight_time_total.append(mean(total_flight_time))
            time_added_total.append(mean(total_delay_time))
            self.data_dict[airline]['avg_flight_time'] = mean(total_flight_time)
        lowest_time_added_airline = ''
        # Calculate the time added per airline, find airline with the lowest time added
        typical_flight_time = mean(delay_time_total) + self.target_flight_time

        lowest_time_added = 0
        for airline in self.airlines:
            time_added = self.data_dict[airline]['avg_flight_time'] - typical_flight_time
            self.data_dict[airline]['time_added'] = time_added
            if lowest_time_added == 0 or time_added < lowest_time_added:
                lowest_time_added = time_added
                lowest_time_added_airline = airline
        self.data_dict['lowest_time_added'] = {'airline': lowest_time_added_airline, 'time_added': lowest_time_added}
        self.data_dict['typical_flight_time_total'] = typical_flight_time

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
        text += f'Typical Flight Time for Route = {round(self.data_dict["typical_flight_time_total"], 2)} minutes\n\n'
        text += f'Time each Airline Adds to Route:\n'
        for airline in self.airlines:
            text += f'{airline}: {round(self.data_dict[airline]["time_added"], 2)} minutes\n'
        text += '\n'
        text += f'Lowest Flight Time Added: \n{self.data_dict["lowest_time_added"]["airline"]} added {round(self.data_dict["lowest_time_added"]["time_added"], 2)} minutes'
        # Write the text string to a txt file
        with open(self.out_file_A, 'w+') as f:
            f.write(text)
        print(text)


class LabOnePartB():
    def __init__(self):
        pass






class emily():
    def __init__(self):
        emily.run(self)
        pass

    def run(self):
        import csv

        infile = open('flighttime.csv','r')
        reader = csv.reader(infile,delimiter = ',')
        data = list(reader)

        import numpy as np
        import matplotlib.pyplot as plt

        # Open output file
        output = open('output.txt', 'w')

        # Read File
        x = []
        with open('flighttime.csv') as file:
            reader = csv.reader(file, delimiter=',')
            for line in reader:
                x.append(line)
        # print(len(x))

        # First with information is to delete the incorrect entries
        # After talking they recommended that I make a list of incorrect entries index numbers
        n = len(x)
        etd = []
        for i in range(1, n):
            flighttime = float(x[i][9])
            if (flighttime < 230):
                etd.append(i)

        # Next we actually delete entries from list
        m = len(etd)
        # print(m)
        for i in range(0, m):
            del x[etd[i] - i]

        # Calculating the number of observations in given data set
        print('Number of observations:', len(x))
        output.write('Number of observations: ')
        output.write(str(len(x)))
        output.write('\n')

        # Calculating target flight time, remember that we have the formula given
        d = 1741.16
        lori = -87.90
        ldes = -118.41
        tft = 0.117 * d + .517 * (lori - ldes) + 20
        print('target flight time:', tft)
        output.write('target flight time: ')
        output.write(str(tft))
        output.write('\n')

        # Calculating typical time of this route
        n = len(x)
        delay = []
        for i in range(1, n):
            totaldelay = float(x[i][6]) + float(x[i][8])
            delay.append(totaldelay)

        meandelay = sum(delay) / len(delay)
        typicaltime = tft + meandelay
        print('Typical time:', typicaltime)
        output.write('Typical time: ')
        output.write(str(typicaltime))
        output.write('\n')

        # To be able to actually look at the information by airline, we need to first organize airlines
        n = len(x)
        AA = []
        F9 = []
        NK = []
        UA = []
        VX = []
        for i in range(1, n):
            airline = x[i][1]
            if (airline in ['AA']):
                AA.append(x[i])
            if (airline in ['F9']):
                F9.append(x[i])
            if (airline in ['NK']):
                NK.append(x[i])
            if (airline in ['UA']):
                UA.append(x[i])
            if (airline in ['VX']):
                VX.append(x[i])
            if (airline not in ['AA', 'F9', 'NK', 'UA', 'VX']):
                print('Error: Extra Airlines')

        listofairlines = ['AA', 'F9', 'NK', 'UA', 'VX']
        listsbyairline = [AA, F9, NK, UA, VX]  # list of lists for each airline
        averageflighttimebyairline = []  # list of average flight time in same order
        numberofairlines = len(listsbyairline)

        for j in range(0, numberofairlines):
            airlinelist = listsbyairline[j]
            n = len(airlinelist)
            total = 0
            for i in range(0, n):
                total = total + float(airlinelist[i][9])
            averageflighttime = total / n
            averageflighttimebyairline.append(averageflighttime)
        # print(averageflighttimebyairline)

        # Finding time added for each airline
        timeadded = []
        for i in range(0, numberofairlines):
            timeadded.append(averageflighttimebyairline[i] - typicaltime)
        # print(timeadded)

        # Finding name of airline with minimum time added
        for i in range(0, numberofairlines):
            print('Time added for', listofairlines[i], ':', timeadded[i])
            output.write('Time added for ')
            output.write(str(listofairlines[i]))
            output.write(': ')
            output.write(str(timeadded[i]))
            output.write('\n')
            if (timeadded[i] in [min(timeadded)]):
                mintimeaddedairline = listofairlines[i]
        print('Airline with lowest time added:', mintimeaddedairline)
        output.write('Airline with lowest time added: ')
        output.write(str(mintimeaddedairline))

        # Closing output file
        output.close()

        # And then finally, we turn our findings into a bar graph
        plt.bar(listofairlines, timeadded, align='center', alpha=1)
        plt.ylabel('Average Time Added')
        plt.title('Average Time Added By Airline')

        #plt.show()


class jake():
    def __init__(self):
        jake.run(self)

    def run(self):
        with open('FlightTime.csv') as file:
            reader = csv.reader(file, delimiter=',')

            cleaned_flights = []

            for line in reader:
                if line[0] == 'Flight Time':
                    continue

                Date = line[0]
                Carrier = line[1]
                Flight_Number = int(line[2])
                Origin = line[3]
                Destination = line[4]
                Departure_Time = line[5]
                Departure_Delay = line[6]
                Arrival_Time = line[7]
                Arrival_Delay = line[8]
                Flight_Time = line[9]

                if Departure_Time == '':
                    continue

                if Arrival_Time == '':
                    continue

                if int(Flight_Time) < 230:
                    continue

                flight_data = {'Date': Date,
                               'Carrier': Carrier,
                               'Flight_Number': Flight_Number,
                               'Origin': Origin,
                               'Destination': Destination,
                               'Departure_Time': int(Departure_Time),
                               'Departure_Delay': int(Departure_Delay),
                               'Arrival_Time': int(Arrival_Time),
                               'Arrival_Delay': int(Arrival_Delay),
                               'Flight_Time': int(Flight_Time)}

                cleaned_flights.append(flight_data)

            file.close()

        ### Answer to 2
        print(len(cleaned_flights))

        d = 1741.16
        l_ori = -87.90
        l_des = -118.41

        TFT = 0.117 * d + 0.517 * (l_ori - l_des) + 20
        ### Answer to 3
        print(TFT)

        departure_delays = []
        arrival_delays = []

        for flight in cleaned_flights:
            depart_delay = flight['Departure_Delay']
            arrive_delay = flight['Arrival_Delay']

            departure_delays.append(depart_delay)
            arrival_delays.append(arrive_delay)

        average_depart_delay = np.mean(departure_delays)
        average_arrive_delay = np.mean(arrival_delays)

        typical_time = TFT + average_arrive_delay + average_depart_delay
        ### Answer to number 4
        print(typical_time)

        airline_dict = {}
        for flight in cleaned_flights:
            carrier = flight['Carrier']

            arrive_delay = flight['Arrival_Delay']
            depart_delay = flight['Departure_Delay']

            flight_time = flight['Flight_Time']

            total_time = flight_time + arrive_delay + depart_delay

            if carrier not in airline_dict:
                airline_dict[carrier] = {}
                airline_dict[carrier]['Total_Times'] = []
            airline_dict[carrier]['Total_Times'].append(total_time)

        ### Answer to number 5
        for carrier in airline_dict:
            print(carrier)
            print(np.mean(airline_dict[carrier]['Total_Times']) - TFT)

        ### Work for Number 6
        outputFile = open('Exercise1Calcs.txt', 'w')

        outputFile.write('Number 2: \n')
        outputFile.write('Number of valid flights: ' + str(len(cleaned_flights)) + ' flights \n\n')

        outputFile.write('Number 3: \n')
        outputFile.write('Target flight time: ' + str(TFT) + ' minutes \n\n')

        outputFile.write('Number 4: \n')
        outputFile.write('Typical time for the route: ' + str(typical_time) + ' minutes \n\n')

        outputFile.write('Number 5: \n')
        for carrier in sorted(airline_dict):
            added_time = np.mean(airline_dict[carrier]['Total_Times']) - TFT
            outputFile.write('Airline ' + carrier + ' adds ' + str(added_time) + ' minutes to the route. \n')

        outputFile.close()


if __name__ == '__main__':
    lab1A = LabOnePartA()
    #lab1B = LabOnePartB()
    #emily = emily()
    #jake = jake()
    plt.show()
