# R: Cumulative Commute Heatmap

## Usage

Note the borders of of your area in `data\borders.txt` as comma separated values in the order left, bottom, right, top.

Start `scraper.r` to scrape all the towns in your area, output to `data\origins.csv`. (Currently only scrapes cities from Baden-Württemberg, Germany)

Note the commuting destinations in `data\destinations.csv`. One per line lat,long with decimal dot.

Run Part 1 of `visualization.r` to create the map with all origins and destinations marked on the map. The Image is saved to `data\visualization.png`.

Run `distance.py`, which will output the data into `data\distances.pickle`.

Run `transform.py` to transform the data into a csv table at `data\dataset.csv`.

Run `visualization.r` to create the visualization in `data\heatmap.png`