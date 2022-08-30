# Julian Lemmerich
# visualizing the data from distance.py

import pickle
import csv

with open('data\distances.pickle', 'rb') as f:
    distances = pickle.load(f)
    # this is a list of dicts now.

## just copied form distance.py

# reading origins and destinations from data directory
origins =  []
with open('data\origins.txt', 'r') as file:
    for line in file:
        origins.append(line.strip('\n'))

# the dataset we're creating is baiscally a set of coords + value associated
# right now for testing its just the cumulative time of the location

dataset = []
for i in range(len(origins)):
    time = distances[i]['rows'][0]['elements'][0]['duration']['value'] + distances[i]['rows'][0]['elements'][1]['duration']['value'] #this is time in seconds. the int between elements and duration gives the destination index
    dataset.append([origins[i], time]) #origins at this point is still a string of the coordinates

# write dataset to csv for plotting with R
with open('data\dataset.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    for l in dataset:
        writer.writerow(l)