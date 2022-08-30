# R: Cumulative Commute Heatmap

## Usage

Manually screenshot the area you want and save to `data\map.jpg`

Note the corners of the screenshot in `data\corners.txt` in topleft, topright, bottomleft, bottomright order. You can just right-click the location in Google Maps and left-click the coordinates that are shown in the menu.

Note all the cities in your area that are of interest in `data\origins.txt` in coordinate form. The order does not matter this time.

Note the commuting destinations in `data\destinations.txt` in the same format.

Run `distance.py`, which will output the data into `data\distances.pickle`.

Run `transform.py` to transform the data into a csv table at `data\dataset.csv`.
