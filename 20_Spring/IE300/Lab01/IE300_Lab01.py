import matplotlib.pyplot as plt
from statistics import mean
import numpy as np
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
        LabOnePartB.lab1BRun(self)

    def lab1BRun(self):
        # Written by Jake Hawkins
        #### Exercise 1 ####
        Table2 = []

        Table2.append({'Origin': 'SEA',
                       'Destination': 'ATL',
                       'Airline': 'Southwest',
                       'Weather': 'Poor',
                       'Delay': 'N'})

        Table2.append({'Origin': 'SEA',
                       'Destination': 'BOS',
                       'Airline': 'American',
                       'Weather': 'Good',
                       'Delay': 'Y'})

        Table2.append({'Origin': 'SEA',
                       'Destination': 'ATL',
                       'Airline': 'United',
                       'Weather': 'Poor',
                       'Delay': 'Y'})

        Table2.append({'Origin': 'SFO',
                       'Destination': 'BOS',
                       'Airline': 'Southwest',
                       'Weather': 'Poor',
                       'Delay': 'Y'})

        Table2.append({'Origin': 'SFO',
                       'Destination': 'ATL',
                       'Airline': 'American',
                       'Weather': 'Good',
                       'Delay': 'N'})

        Table2.append({'Origin': 'SFO',
                       'Destination': 'BOS',
                       'Airline': 'United',
                       'Weather': 'Poor',
                       'Delay': 'N'})

        Table2.append({'Origin': 'SFO',
                       'Destination': 'BOS',
                       'Airline': 'United',
                       'Weather': 'Good',
                       'Delay': 'N'})

        Table2.append({'Origin': 'SEA',
                       'Destination': 'BOS',
                       'Airline': 'United',
                       'Weather': 'Poor',
                       'Delay': 'N'})

        ### Exercise 1 ###
        # SEA-ATL flight on Southwest with good weather. Will it be delayed?

        # Want to maximize P(Ck|X) = P(Ck ∩ X)/P(X), but P(X) is a constant, so we can look
        # for the maximum of P(Ck ∩ X) instead.

        # P(Ck ∩ X) = P(Ck)*P(X|Ck) = P(Ck)*P(x1,...,xn|Ck) = P(Ck)*P(x1|Ck)*P(x2,...,xn|Ck,x1)
        #           = P(Ck)*P(x1|Ck)*P(x2|Ck,x1)*...*P(xn|Ck,x1,x2,...,xn-1)

        # Assume conditional independence between each attribute (hence the "naive")
        # so P(xi|Ck,xj) = P(xi|Ck) where i not equal to j.

        # Therefore, P(Ck|X) ∝ P(Ck)*multiplication(P(xi|Ck), i: 1 -> n)

        # Define classifier: pick most probable class (maximum a posterior (MAP) rule)
        #                       y_hat = argmax_k(P(Ck)*multiplication(P(xi|Ck), i: 1 -> n))

        # To estimate P(xi|Ck), use M-estimates. Therefore,
        # P(xi|Ck) = (n_hat + m*p)/(n + m) where n_hat is the number of observations where C = Ck
        # and X = xi and n is the number of observations where C = Ck.
        # m is the equivalent sample size (in this case it is assumed to be 4). p is the a priori
        # estimate of P(xi|Ck) (a typical estimate is 1/(# of possible values for attribute i))

        cases = []
        out_text = ''

        # Flight Type 1: SEA-ATL on Southwest with good weather
        cases.append(['SEA', 'ATL', 'Southwest', 'Good'])

        # Find P(Ck) = P(Y)
        historical_delays = 0
        for entry in Table2:
            if entry['Delay'] == 'Y':
                historical_delays += 1

        P_Y = historical_delays / len(Table2)
        P_N = 1 - P_Y
        m = 4

        for flight in cases:

            # Estimate P_[origin]_given_Y

            # Find number of possible origins, destinations, carriers, and weather types.
            possible_origins = []
            possible_destinations = []
            possible_carriers = []
            possible_weathers = []

            n_hat_origin_Y = 0
            n_hat_origin_N = 0

            n_hat_destination_Y = 0
            n_hat_destination_N = 0

            n_hat_carrier_Y = 0
            n_hat_carrier_N = 0

            n_hat_weather_Y = 0
            n_hat_weather_N = 0

            n_Y = historical_delays
            n_N = len(Table2) - historical_delays
            for entry in Table2:
                if entry['Origin'] not in possible_origins:
                    possible_origins.append(entry['Origin'])
                if entry['Destination'] not in possible_destinations:
                    possible_destinations.append(entry['Destination'])
                if entry['Airline'] not in possible_carriers:
                    possible_carriers.append(entry['Airline'])
                if entry['Weather'] not in possible_weathers:
                    possible_weathers.append(entry['Weather'])

                if entry['Origin'] == flight[0]:
                    if entry['Delay'] == 'Y':
                        n_hat_origin_Y += 1
                    else:
                        n_hat_origin_N += 1

                if entry['Destination'] == flight[1]:
                    if entry['Delay'] == 'Y':
                        n_hat_destination_Y += 1
                    else:
                        n_hat_destination_N += 1

                if entry['Airline'] == flight[2]:
                    if entry['Delay'] == 'Y':
                        n_hat_carrier_Y += 1
                    else:
                        n_hat_carrier_N += 1

                if entry['Weather'] == flight[3]:
                    if entry['Delay'] == 'Y':
                        n_hat_weather_Y += 1
                    else:
                        n_hat_weather_N += 1

            p_origin = 1 / len(possible_origins)
            p_destination = 1 / len(possible_destinations)
            p_carrier = 1 / len(possible_carriers)
            p_weather = 1 / len(possible_weathers)

            P_origin_given_Y = (n_hat_origin_Y + m * p_origin) / (n_Y + m)
            P_origin_given_N = (n_hat_origin_N + m * p_origin) / (n_N + m)

            P_destination_given_Y = (n_hat_destination_Y + m * p_destination) / (n_Y + m)
            P_destination_given_N = (n_hat_destination_N + m * p_destination) / (n_N + m)

            P_carrier_given_Y = (n_hat_carrier_Y + m * p_carrier) / (n_Y + m)
            P_carrier_given_N = (n_hat_carrier_N + m * p_carrier) / (n_N + m)

            P_weather_given_Y = (n_hat_weather_Y + m * p_weather) / (n_Y + m)
            P_weather_given_N = (n_hat_weather_N + m * p_weather) / (n_N + m)

            # Calculate final estimate
            P_Y_X = P_Y * P_origin_given_Y * P_destination_given_Y * P_carrier_given_Y * P_weather_given_Y
            P_N_X = P_N * P_origin_given_N * P_destination_given_N * P_carrier_given_N * P_weather_given_N

            if P_Y_X > P_N_X:
                will_be_delayed = 'Yes'
            else:
                will_be_delayed = 'No'
            print(flight, P_Y_X, P_N_X, will_be_delayed)
            out_text += f'Flight #{cases.index(flight) + 1}:\n'
            out_text += f'Origin: {flight[0]}\n'
            out_text += f'Destination: {flight[1]}\n'
            out_text += f'Prob. of Delay: {round(P_Y_X, 5)}\n'
            out_text += f'Prob. of No Delay: {round(P_N_X, 5)}\n'
            out_text += f'Will it be Delayed? {will_be_delayed}\n\n'
        print(out_text)

        with open('Output_B1.txt', 'w+') as f:
            f.write(out_text)

        # Exercise 2

        flight_data = []
        with open('FlightDelay.csv') as file:
            reader = csv.reader(file, delimiter=',')

            for line in reader:

                if line[0] == 'Carrier':
                    continue

                Carrier = line[0]
                Origin = line[1]
                Destination = line[2]
                Departure_Delay = int(line[3])
                Arrival_Delay = int(line[4])

                Total_Delay = Departure_Delay + Arrival_Delay

                if Total_Delay > 15:
                    Delayed = 'Y'
                else:
                    Delayed = 'N'

                data = {'Carrier': Carrier,
                        'Origin': Origin,
                        'Destination': Destination,
                        'Departure_Delay': Departure_Delay,
                        'Arrival_Delay': Arrival_Delay,
                        'Total_Delay': Total_Delay,
                        'Delayed': Delayed}

                flight_data.append(data)

            file.close()

        ### Exercise 3 ###

        cases = []
        case_dict = {}
        out_text = ''

        # Flight Type 1: JFK-LAS on American Airlines (AA)
        cases.append(['JFK', 'LAS', 'AA'])

        # Flight Type 2: JFK-LAS on JetBlue (B6)
        cases.append(['JFK', 'LAS', 'B6'])

        # Flight Type 3: SFO-ORD on Virgin Airlines (VX)
        cases.append(['SFO', 'ORD', 'VX'])

        # Flight Type 4: SFO-ORD on Southwest Airlines (WN)
        cases.append(['SFO', 'ORD', 'WN'])

        # Find P(Y) and P(N)
        historical_delays = 0
        for entry in flight_data:
            if entry['Delayed'] == 'Y':
                historical_delays += 1

        P_Y = historical_delays / len(flight_data)
        P_N = 1 - P_Y
        m = 3

        # Iterate over each case.
        for flight in cases:

            # Define variables to hold unique characteristics
            possible_origins = []
            possible_destinations = []
            possible_carriers = []

            # Define counters
            n_hat_origin_Y = 0
            n_hat_origin_N = 0
            n_hat_destination_Y = 0
            n_hat_destination_N = 0
            n_hat_carrier_Y = 0
            n_hat_carrier_N = 0

            # Total number of delays and non-delays
            n_Y = historical_delays
            n_N = len(flight_data) - historical_delays

            # Analyze the data for each flight.
            for entry in flight_data:
                # Add characteristic to the appropriate list if it has never been seen before.
                if entry['Origin'] not in possible_origins:
                    possible_origins.append(entry['Origin'])
                if entry['Destination'] not in possible_destinations:
                    possible_destinations.append(entry['Destination'])
                if entry['Carrier'] not in possible_carriers:
                    possible_carriers.append(entry['Carrier'])

                # Check if the Origin matches the case and determine if it was delayed or not.
                if entry['Origin'] == flight[0]:
                    if entry['Delayed'] == 'Y':
                        n_hat_origin_Y += 1
                    else:
                        n_hat_origin_N += 1

                # Check if the Destination matches the case and determine if it was delayed or not.
                if entry['Destination'] == flight[1]:
                    if entry['Delayed'] == 'Y':
                        n_hat_destination_Y += 1
                    else:
                        n_hat_destination_N += 1

                # Check if the Carrier matches the case and determine if it was delayed or not.
                if entry['Carrier'] == flight[2]:
                    if entry['Delayed'] == 'Y':
                        n_hat_carrier_Y += 1
                    else:
                        n_hat_carrier_N += 1

            # Determine the estimate for the probability of each characteristic
            p_origin = 1 / len(possible_origins)
            p_destination = 1 / len(possible_destinations)
            p_carrier = 1 / len(possible_carriers)

            # Apply estimate to each type of variable given delay and not delayed
            P_origin_given_Y = (n_hat_origin_Y + m * p_origin) / (n_Y + m)
            P_origin_given_N = (n_hat_origin_N + m * p_origin) / (n_N + m)

            P_destination_given_Y = (n_hat_destination_Y + m * p_destination) / (n_Y + m)
            P_destination_given_N = (n_hat_destination_N + m * p_destination) / (n_N + m)

            P_carrier_given_Y = (n_hat_carrier_Y + m * p_carrier) / (n_Y + m)
            P_carrier_given_N = (n_hat_carrier_N + m * p_carrier) / (n_N + m)

            # Calculate final estimate
            P_Y_X = P_Y * P_origin_given_Y * P_destination_given_Y * P_carrier_given_Y
            P_N_X = P_N * P_origin_given_N * P_destination_given_N * P_carrier_given_N

            if P_Y_X > P_N_X:
                will_be_delayed = 'Yes'
            else:
                will_be_delayed = 'No'
            case_dict[f'case {cases.index(flight)+1}'] = {'Origin': flight[0], 'Destination': flight[1], 'Carrier': flight[2],
                                                          'Probability of no delay': P_Y_X, 'Probability of delay': P_N_X,
                                                          'Delay?': will_be_delayed}
            print(flight, P_Y_X, P_N_X, will_be_delayed)
            out_text += f'Flight #{cases.index(flight) + 1}:\n'
            out_text += f'Origin: {flight[0]}\n'
            out_text += f'Destination: {flight[1]}\n'
            out_text += f'Prob. of Delay: {round(P_Y_X, 5)}\n'
            out_text += f'Prob. of No Delay: {round(P_N_X, 5)}\n'
            out_text += f'Will it be Delayed? {will_be_delayed}\n\n'
        print(out_text)

        with open('Output_B3.txt', 'w+') as f:
            f.write(out_text)


if __name__ == '__main__':
    #lab1A = LabOnePartA()
    lab1B = LabOnePartB()
    plt.show()
