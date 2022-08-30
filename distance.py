# Julian Lemmerich
# getting distance data for a list of coordinates from Google Maps

import googlemaps

# read key from file to not leak!
with open('api.key', 'r') as file:
    key = file.read().rstrip()

gmaps = googlemaps.Client(key=key)

distances = gmaps.distance_matrix(origins="Eppingen, Germany", destinations=["Heilbronn, Germany", "Karlsruhe, Germany"], mode="driving", region="de")

print(distances)