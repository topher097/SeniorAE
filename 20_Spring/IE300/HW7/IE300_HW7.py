"""
Author:         Christopher Endres
Subject:        IE300
Assignment:     Homework 7
Date:           4/15/2020
"""

import numpy as np
from statistics import mean, variance
import matplotlib.pyplot as plt

# Question 3

# Extract data from csv file, numbers are hours until depletion of batteries
data = []
battery = []
bat_count = 1
with open('HW7_DATA.csv', 'r') as f:
    for line in f:
        battery.append(bat_count)
        data.append(float(line))
        bat_count += 1
data = [4.1, 4.3, 4.8, 6.5, 6.7, 8.0, 8.4, 10.5]
# Calculate the mean, variance, quartiles, IQR, and range of data (from HW6)
data_mean = mean(data)
data_variance = variance(data)
data_q1 = np.percentile(data, 25)
data_q2 = np.percentile(data, 50)
data_q3 = np.percentile(data, 75)
data_IQR = data_q3 - data_q1
data_range = max(data) - min(data)

# Create a box plot of the data
plot_string = f'Mean = {round(data_mean,2)} hours\n' \
              f'Variance = {round(data_variance,2)} hours\n' \
              f'First Quartile = {round(data_q1,2)} hours\n' \
              f'Median = {round(data_q2,2)} hours\n' \
              f'Third Quartile = {round(data_q3,2)} hours\n' \
              f'IQR = {round(data_IQR,2)} hours\n' \
              f'Range = {round(data_range,2)} hours'
font_dict = {'fontsize': 11}
f = plt.figure()
ax = f.add_subplot(111)
ax.boxplot(data)
ax.set_xlim([.8, 1.6])
ax.set_title('Box Plot of Hours Before Battery Depletion', fontsize=16)
ax.text(.53, .97, plot_string, fontdict=font_dict, bbox=dict(facecolor='none', edgecolor='k', boxstyle='round'), verticalalignment='top', transform=ax.transAxes)
ax.set_ylabel('Hours', fontsize=14)
f.savefig('HW7 Box Plot.png')
plt.draw()

# Create a histogram plot of the data
g = plt.figure()
ax = g.add_subplot(111)
ax.hist(data, bins=12, range=(78, 82), edgecolor='k')
hist, bin_edges = np.histogram(data, bins=12)
ax.set_title('Histogram of Hours Before Battery Depletion', fontsize=16)
ax.set_xlabel('Hours', fontsize=14)
ax.set_ylabel('Frequency', fontsize=14)
g.savefig('HW7 Histogram.png')
plt.draw()
print(hist)
print(bin_edges)

plt.show()