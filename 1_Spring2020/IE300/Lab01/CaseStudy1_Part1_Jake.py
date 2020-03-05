import csv
import numpy as np
import matplotlib.pyplot as plt




with open('FlightTime.csv') as file:
    reader = csv.reader(file,delimiter=',')



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


TFT = 0.117*d + 0.517*(l_ori - l_des) + 20
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
outputFile = open('Exercise1Calcs.txt','w')

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







##### Exercise 2 #####
x = range(1,len(airline_dict)+1)

airline_labels = []
added_times = []
for carrier in airline_dict:
    airline_labels.append(carrier)
    added_times.append(np.mean(airline_dict[carrier]['Total_Times']) - TFT)

plt.bar(airline_labels, added_times)
plt.show()
