import numpy as np
from statistics import mean, variance

# Import data from csv file
data = []
with open('HW6_DATA.csv', 'r') as f:
    for line in f:
        data.append(float(line))
data = [4.1, 4.3, 4.8, 6.5, 6.7, 8.0, 8.4, 10.5]

# Part A, find the mean
data_mean = mean(data)
print(f'A) {data_mean}')

# Part B, find the variance
data_variance = variance(data)
print(f'B) {data_variance}')

# Part C, find the first quartile, q1
data_q1 = np.percentile(data, 25)
print(f'C) {data_q1}')

# Part D, find the median, q2
data_q2 = np.percentile(data, 50)
print(f'D) {data_q2}')

# Part E, find the third quartile, q3
data_q3 = np.percentile(data, 75)
print(f'E) {data_q3}')

# Part F, find the interquartile, IQR
data_IQR = data_q3 - data_q1
print(f'F) {data_IQR}')

# Part G, find the range, r
data_r = max(data) - min(data)
print(f'G) {data_r}')