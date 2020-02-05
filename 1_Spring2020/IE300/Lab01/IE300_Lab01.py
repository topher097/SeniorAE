import numpy as np
import os
import csv

in_file = os.path.join(os.getcwd(), 'LabDemo.csv')

out_file = os.path.join(os.getcwd(), 'CustomerSummary.csv')

read_file = []
lines = []
with open(in_file, 'r') as file:
    reader = csv.reader(file)
    lines = list(reader)

customer_dict = {}
customers = []
objects = []

for line in lines[1:]:
    customer = line[0]
    object = line[1]
    quantity = line[2]
    price = line[3]


    if customer not in customer_dict.keys():
        customer_dict[customer] = {}
    
    if object not in customer_dict[customer].keys():
        customer_dict[customer][object] = {'quantity': 0, 'cost': 0}

    # Get the current info for customer, object, quantity, and cost



