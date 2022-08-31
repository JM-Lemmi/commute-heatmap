# Julian Lemmerich
# getting distance data for a list of coordinates from Google Maps

import googlemaps
import pickle

# read key from file to not leak!
with open('api.key', 'r') as file:
    key = file.read().rstrip()
gmaps = googlemaps.Client(key=key)

# reading origins and destinations from data directory
origins =  []
with open('data\origins.csv', 'r') as file:
    for line in file:
        origins.append(line)

destinations = []
with open('data\destinations.csv', 'r') as file:
    for line in file:
        destinations.append(line)

# using maps api to get the distances. splitting by origins to circumvent MAX_ELEMENTS_EXCEEDED and MAX_DIMENSIONS_EXCEEDED
distance = []
for o in origins:
    distance.append(gmaps.distance_matrix(origins=o, destinations=destinations, mode="driving", region="de"))

# write the results to file to save on api calls later
with open('data\distances.pickle', 'wb') as file:
    pickle.dump(distance, file, pickle.HIGHEST_PROTOCOL)
