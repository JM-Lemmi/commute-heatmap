:: Julian Lemmerich
:: Running the full heatmap creation in one command

@echo off

:: check if the required files exist
if exist ./data/borders.txt (
    echo borders.txt exists
) else (
    exit /b 1
)

if exist ./data/osm.osm.pbf (
    echo osm.osm.pbf exists
) else (
    exit /b 1
)

if exist ./data/destinations.csv (
    echo destinations.csv exists
) else (
    exit /b 1
)

if exist ./api.key (
    echo api.key exists
) else (
    exit /b 1
)

echo starting scrape.py
python ./scrape.py

echo starting distance.py and transform.py
python ./distance.py
python ./transform.py

echo starting visualization.r
Rscript ./visualization.r
