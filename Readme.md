# R: Cumulative Commute Heatmap

## Example

### multiple destinations

![](./.github/visualization-cum.png)

### single destination

![](./.github/visualization-1.png)

## Usage

### Install

You need to install some preqrequisites: The languages R and python and some packages for each are required.

You can install the python packages with `pip install -r requirements.txt` and the R packages with `Rscript requirements.r`.

### Run

1. Note the borders of of your area in `data\borders.txt` as comma separated values in the order left, bottom, right, top.
2. Download an osm extract for your area, for example Germany from here: https://download.geofabrik.de/europe/germany.html<br>Put the osm file in the `data` folder and rename it to `osm.osm.pbf`.
    * If you have a more narrow choice of origins, you can also manually add them to `data\origins.csv`. The format is: `lat,lon`.
3. Install the Python packages with `pip install -r requirements.txt`.
4. Start `scraper.py` to scrape all the towns in your area, output to `data\origins.csv`.<br>This can really take a while. My initial testing with the full german osm would run out of memory. The smaller the extract (only one federal state for example) the faster probably, but if your area overlaps multiple Federal States, thats not that easy.
5. Note the commuting destinations in `data\destinations.csv`. One per line lat,long with decimal dot and the commuting mode ("driving", "transit", "bicycling", "walking").
    * If you want to viualize the locations, you can run the first part of `visualization.r`.
    * Right now only 2 destinations are supported.
6. Copy your Google Maps API key to `api.key`. It needs access to the [Distance Matrix API](https://developers.google.com/maps/documentation/distance-matrix/overview).
7. Run `distance.py`, which will output the data into `data\distances.pickle`.
8. Run `transform.py` to transform the data into a csv table at `data\dataset.csv`.
9. Run `visualization.r` to create the heatmaps.<br> 3 Maps will be output: Cumulative `data\visualization-cum.png` and one each for the destinations.

## Detailed information

### scrape.py

Scrapes all the towns in the area and outputs them to `data\origins.csv`. The format is: `lat,lon`.

The script uses osmium with an osm extract for full ofline use.

By default it selects all nodes with place tag "town", "village", "city" and "suburb". This may be too detailled for you. Or if you only want to use it for once city you could select all single addresses in a city, or all trainstations in an area. Since `origins.csv`, which is later used for the distance calculation is only coordinates, you can choose any filter that you want.
