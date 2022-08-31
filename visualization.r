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
colnames(coords.frame) <- c("Latitude", "Longitude", "Time")

## way one

# i know this is a stupid solution, but hear me out!
# there are many stackoverflow posts, that want the exact same visualization, that I want with ggplot2:
# https://stackoverflow.com/q/64774664/9397749
# https://stackoverflow.com/q/32148564/9397749
# https://stackoverflow.com/q/46975986/9397749
# https://stackoverflow.com/q/38592691/9397749
# and the answers are all useless. Instead of using a value they want to use the density2d visualization, which is not something practical for me.
# so this loop repeats the coordinates times the value I want to display to basically manually create the graph I want. Its very slow, but until I find something better it at least should work.
# the first run has been going for over 15min now, so i'll cancel that but still keep it in mind!
coords.density <- list()
for (i in 1:length(coords.data[[1]])) {
    for (j in 1:floor(coords.data[[3]][i]/60)) { #/60 improves the performance, and reduces time accuracy to minutes
        coords.density <- append(coords.density, list(c(coords.data[[1]][i], coords.data[[2]][i])))
    }
}
coords.density.df <- as.data.frame(do.call(rbind, coords.density))
colnames(coords.density.df) <- c("Latitude", "Longitude")

coords.map <- coords.map +
    stat_density2d(data=coords.density.df,  aes(x=Longitude, y=Latitude, fill=..level.., alpha=..level..), geom="polygon") +
    scale_fill_gradientn(colours=rev(brewer.pal(7, "Spectral")))

### general ###

coords.map <- coords.map + theme_bw()
ggsave(filename="./data/visualization.png")
