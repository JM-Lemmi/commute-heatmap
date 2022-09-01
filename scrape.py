# Julian Lemmerich
# getting all cities with their location from an osm file

import osmium
import csv

class CityHandler(osmium.SimpleHandler):
    def __init__(self):
        super(CityHandler, self).__init__()
        self.cities = []

        # reading borders
        with open("./data/borders.txt", 'r') as file:
            borderstr = file.read().strip('\n').split(",")
            self.borders = [float(borderstr[0]), float(borderstr[1]), float(borderstr[2]), float(borderstr[3])]

    def node(self, n):
        if 'place' in n.tags:
            if n.tags.get('place') == 'city' or n.tags.get('place') == 'town' or n.tags.get('place') == 'suburb':
                if float(self.borders[1]) < n.location.lat < float(self.borders[3]) and float(self.borders[0]) < n.location.lon < float(self.borders[2]):
                    print("matched! " + n.tags.get('name') + ", " + str(n.location.lat) + ", " + str(n.location.lon))
                    self.cities.append([n.location.lat, n.location.lon])

c = CityHandler()
c.apply_file("./data/osm.osm.pbf", locations=True)

# write cities to csv for plotting with R
with open('data\origins.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    for l in c.cities:
        writer.writerow(l)
