import numpy as np
import os
import csv

in_file = os.path.join(os.getcwd(), 'LabDemo2.csv')

out_file = os.path.join(os.getcwd(), 'CustomerSummary.txt')

read_file = []
lines = []
with open(in_file, 'r') as file:
    reader = csv.reader(file)
    lines = list(reader)

customer_dict = {}
customers = []
objects = []

# Write dictionary of customers, objects, and costs
for line in lines[1:]:
    customer = line[0]
    object = line[1]
    quantity = int(line[2])
    cost = float(line[3])*quantity
    if customer not in customer_dict.keys():
        customer_dict[customer] = {}
        customers.append(customer)
    
    if object not in customer_dict[customer].keys():
        customer_dict[customer][object] = {'quantity': 0, 'cost': 0}

    if object not in objects:
        objects.append(object)

    # Get the current info for customer, object, quantity, and cost
    curr_quantity = customer_dict[customer][object]['quantity']
    curr_cost = customer_dict[customer][object]['cost']

    # Update the current info with
    customer_dict[customer][object]['quantity'] = curr_quantity + quantity
    customer_dict[customer][object]['cost'] = curr_cost + cost


# Go through each customer and save info to a text file
text = ''
for customer in customers:
    text += f'Customer: {customer}\n'
    for object in objects:
        if object not in customer_dict[customer].keys():
            avg_price = 'No purchase history'
            text += f'Average price for {object}: {avg_price}\n'
        else:
            cost = customer_dict[customer][object]['cost']
            quantity = customer_dict[customer][object]['quantity']
            avg_price = round(cost/quantity, 2)
            text += f'Average price for {object}: ${avg_price}\n'
    text += '\n'

# Write the text string to a txt file
with open(out_file, 'w+') as f:
    f.write(text)

