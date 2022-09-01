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
heatmap.base <- ggmap(stamenmap, extent="device", legend="none")

### 1 ###

#ORIGINS

# load coords from file
origins <- read.csv(file="./data/origins.csv", header = FALSE)
origins.df <- data.frame(origins[[1]], origins[[2]])
colnames(origins.df) <- c("Latitude","Longitude")

# paint dots on map
heatmap.base <- heatmap.base + geom_point(data=origins.df,  aes(x=Longitude, y=Latitude), fill="red", shape=23, alpha=0.8)

#DESTINATIONS
# load coords from file
dest <- read.csv(file="./data/destinations.csv", header = FALSE)
dest.df <- data.frame(dest[[1]], dest[[2]])
colnames(dest.df) <- c("Latitude","Longitude")

# paint dots on map
# at this point we split into three heatmaps: cumulative and one for each destination
heatmap.cumulative <- heatmap.base + geom_point(data=dest.df,  aes(x=Longitude, y=Latitude), fill="green", shape=23, alpha=0.8)
heatmap.1 <- heatmap.cumulative + geom_point(aes(x=dest.df$Longitude[1], y=dest.df$Latitude[1]), fill="green", shape=23, alpha=0.8)
heatmap.2 <- heatmap.cumulative + geom_point(aes(x=dest.df$Longitude[2], y=dest.df$Latitude[2]), fill="green", shape=23, alpha=0.8)

### 2 ###

coords.data <- read.csv(file="./data/dataset.csv")
coords.frame <- data.frame(coords.data[[1]], coords.data[[2]], coords.data[[3]], coords.data[[4]], coords.data[[5]])
colnames(coords.frame) <- c("Latitude", "Longitude", "Time", "origin1", "origin2")

# limitierung auf 3h, um bessere plotfarben zu bekommen
for (i in 1:length(coords.frame$Time)) {
    if (coords.frame$Time[i] > 10800) {
        coords.frame$Time[i] = 10800
    }
}

#cumulative
coords.frame.cumulative=data.frame(coords.frame$Latitude, coords.frame$Longitude, coords.frame$Time)
#https://stackoverflow.com/a/42984201/9397749
mba.cum <- mba.surf(coords.frame.cumulative, 300, 300, extend=T)
dimnames(mba.cum$xyz.est$z) <- list(mba.cum$xyz.est$x, mba.cum$xyz.est$y)
df3.cum <- melt(mba.cum$xyz.est$z, varnames = c('Latitude', 'Longitude'), value.name = 'Time')

heatmap.cumulative <- heatmap.cumulative +
    geom_raster(data=df3.cum, aes(x=Longitude, y=Latitude, fill=Time), alpha=0.25) +
    scale_fill_gradientn(colours = matlab.like2(7)) +
    coord_cartesian() #https://stackoverflow.com/a/61899479/9397749

#1
#cumulative
coords.frame.1=data.frame(coords.frame$Latitude, coords.frame$Longitude, coords.frame$origin1)
#https://stackoverflow.com/a/42984201/9397749
mba.1 <- mba.surf(coords.frame.1, 300, 300, extend=T)
dimnames(mba.1$xyz.est$z) <- list(mba.1$xyz.est$x, mba.1$xyz.est$y)
df3.1 <- melt(mba.1$xyz.est$z, varnames = c('Latitude', 'Longitude'), value.name = 'Time')

heatmap.1 <- heatmap.1 +
    geom_raster(data=df3.1, aes(x=Longitude, y=Latitude, fill=Time), alpha=0.25) +
    scale_fill_gradientn(colours = matlab.like2(7)) +
    coord_cartesian() #https://stackoverflow.com/a/61899479/9397749


#2
#cumulative
coords.frame.2=data.frame(coords.frame$Latitude, coords.frame$Longitude, coords.frame$origin2)
#https://stackoverflow.com/a/42984201/9397749
mba.2 <- mba.surf(coords.frame.2, 300, 300, extend=T)
dimnames(mba.2$xyz.est$z) <- list(mba.2$xyz.est$x, mba.2$xyz.est$y)
df3.2 <- melt(mba.2$xyz.est$z, varnames = c('Latitude', 'Longitude'), value.name = 'Time')

heatmap.2 <- heatmap.2 +
    geom_raster(data=df3.2, aes(x=Longitude, y=Latitude, fill=Time), alpha=0.25) +
    scale_fill_gradientn(colours = matlab.like2(7)) +
    coord_cartesian() #https://stackoverflow.com/a/61899479/9397749

### general ###

heatmap.cumulative <- heatmap.cumulative + theme_bw()
heatmap.1 <- heatmap.1 + theme_bw()
heatmap.2 <- heatmap.2 + theme_bw()
ggsave(filename="./data/visualization-cum.png", plot=heatmap.cumulative)
ggsave(filename="./data/visualization-1.png", plot=heatmap.1)
ggsave(filename="./data/visualization-2.png", plot=heatmap.2)
