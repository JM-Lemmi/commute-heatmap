# Julian Lemmerich
# 1: Visualize geolocation dots on a map
# 2: Visualize coords with associated value as a heatmap

### general ###

library(ggplot2)
library(ggmap)
library(RColorBrewer)

library(MBA)
# heatmap https://stackoverflow.com/a/42984201/9397749
library(lubridate)
library(reshape2)
library(colorRamps)
library(scales)

# get the borders of the map from ./data/borders.txt
borders <- scan(file = "./data/borders.txt", what = numeric(), sep = ",")

map_bounds <- c(left = borders[1], bottom = borders[2], right = borders[3], top = borders[4])
stamenmap <- get_stamenmap(map_bounds, zoom = 12, maptype = "toner-lite")
coords.map <- ggmap(stamenmap, extent="device", legend="none")

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
colnames(coords.frame) <- c("Latitude", "Longitude", "Time")

# limitierung auf 3h, um bessere plotfarben zu bekommen
for (i in 1:length(coords.frame$Time)) {
    if (coords.frame$Time[i] > 10800) {
        coords.frame$Time[i] = 10800
    }
}

coords.frame=coords.frame[ order(coords.frame[,1], coords.frame[,2],coords.frame[,3]), ]
#https://stackoverflow.com/a/42984201/9397749
mba <- mba.surf(coords.frame, 300, 300, extend=T)
dimnames(mba$xyz.est$z) <- list(mba$xyz.est$x, mba$xyz.est$y)
df3 <- melt(mba$xyz.est$z, varnames = c('Latitude', 'Longitude'), value.name = 'Time')

coords.map <- coords.map +
    geom_raster(data=df3, aes(x=Longitude, y=Latitude, fill=Time), alpha=0.25) +
    scale_fill_gradientn(colours = matlab.like2(7)) +
    coord_cartesian() #https://stackoverflow.com/a/61899479/9397749

### general ###

coords.map <- coords.map + theme_bw()
ggsave(filename="./data/visualization.png")
