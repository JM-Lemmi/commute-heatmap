# Julian Lemmerich
# 1: Visualize geolocation dots on a map
# 2: Visualize coords with associated value as a heatmap

### general ###

library(ggplot2)
library(ggmap)
library(RColorBrewer)
library(MBA)
library(fields)

# get the borders of the map from ./data/borders.txt
borders <- scan(file = "./data/borders.txt", what = numeric(), sep = ",")

map_bounds <- c(left = borders[1], bottom = borders[2], right = borders[3], top = borders[4])
coords.map <- get_stamenmap(map_bounds, zoom = 12, maptype = "toner-lite")
coords.map <- ggmap(coords.map, extent="device", legend="none")

### 1 ###

#ORIGINS

# load coords from file
origins <- read.csv(file="./data/origins.csv", header = FALSE)
origins.df <- data.frame(origins[[1]], origins[[2]])
colnames(origins.df) <- c("Latitude","Longitude")

# paint dots on map
coords.map <- coords.map + geom_point(data=origins.df,  aes(x=Longitude, y=Latitude), fill="red", shape=23, alpha=0.8)

#DESTINATIONS
# load coords from file
dest <- read.csv(file="./data/destinations.csv", header = FALSE)
dest.df <- data.frame(dest[[1]], dest[[2]])
colnames(dest.df) <- c("Latitude","Longitude")

# paint dots on map
coords.map <- coords.map + geom_point(data=dest.df,  aes(x=Longitude, y=Latitude), fill="green", shape=23, alpha=0.8)

### 2 ###

coords.data <- read.csv(file="./data/dataset.csv")
coords.frame <- data.frame(coords.data[[1]], coords.data[[2]], coords.data[[3]])

coords.frame=coords.frame[ order(coords.frame[,1], coords.frame[,2],coords.frame[,3]), ]
mba.int <- mba.surf(coords.frame, 300, 300, extend=T)$xyz.est
heatmap <- fields::image.plot(mba.int)

### general ###

coords.map <- coords.map + theme_bw()
ggsave(filename="./data/visualization.png")
