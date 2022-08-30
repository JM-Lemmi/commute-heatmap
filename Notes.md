# Scripting Plan

The basic structure of this script should be

* Find all places in a given coordinate range, that are actually livable places
* Calculate the time of commute to each workplace
* Load a Map and overlay a Heatmap visualization


## Coordinates

In Germany one Breitengrad equals 71,44km.
One Längengrad globally equals 111,13km.

For this script 3 decimal positions are sufficient, that equals about 70m x 111m

coordinates upper left: 49.428483, 8.627629
coordinates bottom right: 49.108580, 9.277196

## APIs

### Overpass API

There is an Openstreetmaps Read only API that allows querying for the nearest "way". This would probably also return an error, if there is no street around.
There are public APIs availible, they are however of course not meant to be queried for massive amounts of data. 
Alternatively there is a Docker Image that clones an Overpass Server and then gives a local API.

* [R osmdata](https://github.com/ropensci/osmdata)
* [OSM public APIs](https://wiki.openstreetmap.org/wiki/Overpass_API#Public_Overpass_API_instances)
* [Docker Overpass API](https://hub.docker.com/r/wiktorn/overpass-api)

```
way
  [name];
  (around:100,47.9928,37.8052)
```

from https://forum.openstreetmap.org/viewtopic.php?id=22752

### Car commute

#### **online API**

The [Google Directions API](https://developers.google.com/maps/documentation/directions/overview?hl=de) does sadly no longer have a free tier. DistanceMatrix may also be an alternative. Costs are 0.005 USD per Distance. Restricting to once per Dorf may keep the cost livable.

Alternatively a self-hosted OSMR instance can be used.

This however does not give ÖPNV commutes.

* [Docker OSRM-backend](https://hub.docker.com/r/osrm/osrm-backend/)
* [R osrm](https://www.rdocumentation.org/packages/osrm/versions/3.5.0)

#### **offline route planner**

Instead of using an API and localhost docker container API clone, maybe use the [opentripplanner](https://cran.r-project.org/web/packages/opentripplanner/vignettes/opentripplanner.html) package for R to calculate directly with an OTP file.

### ÖPNV commute

#### **online API**

There is a standardized API for ÖPNV in Germany, that the VRN also supports: TRIAS

* [VRN Opendata API Overview](https://www.vrn.de/opendata/API)
* [VRN API Examples](https://www.vrn.de/opendata/node/115)

There is no ready to use TRIAS API R-package.

#### **offline route planner**

Another option would be offline routing calculation. Since we don't need real time traffic updates, a static [GTFS](https://developers.google.com/transit/gtfs/)-Dataset can also be used.

* [Soll-Fahrplandaten GTFS VRN](https://www.vrn.de/opendata/datasets/soll-fahrplandaten-gtfs)
* [Haltestellen VRN](https://www.vrn.de/opendata/datasets/haltestellen)
* [R gtfsrouter](https://cran.r-project.org/web/packages/gtfsrouter/vignettes/gtfsrouter.html)

```r
f <- file.path (tempdir (), "vbb.zip")
gtfs <- extract_gtfs (f)
route <- gtfs_route (gtfs,
                     from = from,
                     to = to,
                     start_time = "12:00:00",
                     day = "Sunday")
```
