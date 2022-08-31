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
        origins.append(line.strip('\n').split(",", 2))

# we dont need the destinations, only the number of them, so we use
# https://stackoverflow.com/a/1019572/9397749
numdest = sum(1 for line in open('data\destinations.csv'))

# the dataset we're creating is baiscally a set of coords + value associated
# right now for testing its just the cumulative time of the location

# dataset ist eine matrix von o zeilen und 3+d spalten (oring lat, orig long, sum, single values...)
dataset = [[0 for x in range(2+numdest+1)] for y in range(len(origins))] 
for j in range(numdest):                            #destination loop
    for i in range(len(origins)):                   #origin loop
        dataset[i][0] = origins[i][0]               #origins are split into lat and long
        dataset[i][1] = origins[i][1]
        if distances[i+(j*len(origins))]['rows'][0]['elements'][0]['status'] == 'OK':
            dataset[i][3+j] = distances[i+(j*len(origins))]['rows'][0]['elements'][0]['duration']['value'] #this is time in seconds. the int between elements and duration gives the destination index
                                # i+(j*len(origins)) weil wir ja weiterloopen nachdem wir alle origins durchhaben. das heißt bei j=1 muss dann immer einmal die länge von origins aufaddiert werden usw, damit die werte sich nicht wiederholen
        else: # in case there is no connection possible, or an error occurs
            dataset[i][3+j] = 7200 # this value should be higher than anything else, but not too high as to make the rest of the data basically invisible.


# then the sum of all the time values we collected
for k in range(len(dataset)):
    dataset[k][2] = sum(dataset[k][3:])

# write dataset to csv for plotting with R
with open('data\dataset.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Latitude","Longitude","Time"] + list(range(numdest)))
    for l in dataset:
        writer.writerow(l)
