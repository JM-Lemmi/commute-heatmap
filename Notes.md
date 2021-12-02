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

### Car commute

The [Google Directions API](https://developers.google.com/maps/documentation/directions/overview?hl=de) does sadly no longer have a free tier. Alternatively a self-hosted OSMR instance can be used.
This however does not give ÖPNV commutes.

* https://hub.docker.com/r/osrm/osrm-backend/
* https://www.rdocumentation.org/packages/osrm/versions/3.5.0

### ÖPNV commute

There is a standardized API for ÖPNV in Germany, that the VRN also supports: TRIAS

* https://www.vrn.de/opendata/API
* https://www.vrn.de/opendata/node/115

There is no ready to use TRIAS API R-package.