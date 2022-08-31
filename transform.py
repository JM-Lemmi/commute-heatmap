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
with open('data\origins.csv', 'r') as file:
    for line in file:
        origins.append(line.strip('\n').split(", ", 2))

# the dataset we're creating is baiscally a set of coords + value associated
# right now for testing its just the cumulative time of the location

dataset = []
for i in range(len(origins)):
    time = distances[i]['rows'][0]['elements'][0]['duration']['value'] + distances[i]['rows'][0]['elements'][1]['duration']['value'] #this is time in seconds. the int between elements and duration gives the destination index
    dataset.append(origins[i] + [time]) #origins are split into lat and long

# write dataset to csv for plotting with R
with open('data\dataset.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Latitude","Longitude","Time"])
    for l in dataset:
        writer.writerow(l)

#TODO outputs dataset with coords as string instead of two doubles. currently fixing manually by replaicing all " with nothing