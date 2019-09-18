
'''
Find the rate at which the onboard code runs
1. Import data, parse into lists
2. Sum the counter variable for 100 data points (we set our data rate to 1 Hz
3. Average the board run rate over full flight time to get solution
'''

import scipy.interpolate
import numpy as np

# Import the data file, read lines
with open('data.csv', 'rt') as data:
    # Create empty lists to sort the data
    for line in data:
