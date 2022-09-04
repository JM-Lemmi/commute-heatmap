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

library(svglite)

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
colnames(origins.df) <- c("lat","lon")

# paint dots on map
heatmap.base <- heatmap.base + geom_point(data=origins.df,  aes(x=lon, y=lat), fill="red", shape=23, alpha=0.8)

#DESTINATIONS
# load coords from file into data frame
dest <- read.csv(file="./data/destinations.csv", header = FALSE)
dest.df <- data.frame(dest[[1]], dest[[2]])
colnames(dest.df) <- c("lat","lon")

destcount <- length(dest.df$lat)

# paint dots on map
# at this point we split into three heatmaps: cumulative and one for each destination
heatmap.cumulative <- heatmap.base + geom_point(data=dest.df,  aes(x=lon, y=lat), fill="green", shape=23, alpha=0.8)

singleheatmaps <- list()
for (i in 1:destcount) {
  singleheatmaps[[i]] <- heatmap.base + geom_point(aes(x=dest.df$lon[i], y=dest.df$lat[i]), fill="green", shape=23, alpha=0.8)
}

### 2 ###

coords.data <- read.csv(file="./data/dataset.csv")
coords.frame <- data.frame(coords.data)
colnames(coords.frame)[1:3] <- c("lat", "lon", "Time")

create_heatmap <- function(coords.frame, basemap, contour=FALSE) { # coords.frame is a data.frame with lat, lon, Time, basemap a ggplot, contour if the contour should be done
    #https://stackoverflow.com/a/42984201/9397749
    mba <- mba.surf(coords.frame, 300, 300, extend=T)
    dimnames(mba$xyz.est$z) <- list(mba$xyz.est$x, mba$xyz.est$y)
    df3 <- melt(mba$xyz.est$z, varnames = c('lat', 'lon'), value.name = 'Time')

    heatmap <- basemap +
        geom_raster(data=df3, aes(x=lon, y=lat, fill=Time), alpha=0.25) +
        scale_fill_gradientn(colours = matlab.like2(7)) +
        coord_cartesian() #https://stackoverflow.com/a/61899479/9397749
    
    if (contour) {
        heatmap <- heatmap + geom_contour(data=df3.1, aes(z = Time), color="grey", binwidth = 10*60)
    }

    return(heatmap)
}

#cumulative plot
heatmap.cumulative <- create_heatmap(data.frame(coords.frame$lat, coords.frame$lon, coords.frame$Time), heatmap.cumulative)

#single plots
for (i in 1:destcount) {
  singleheatmaps[[i]] <- create_heatmap(data.frame(coords.frame$lat, coords.frame$lon, coords.frame[[i+3]]), singleheatmaps[[i]], contour=TRUE)
}


### general ###

#apply theme
heatmap.cumulative <- heatmap.cumulative + theme_bw()
for (i in 1:destcount) {
  singleheatmaps[[i]] <- singleheatmaps[[i]] + theme_bw()
}

#save plots
ggsave(filename="./data/visualization-cum.svg", plot=heatmap.cumulative)
for (i in 1:destcount) {
  ggsave(filename=paste0("./data/visualization-",i,".svg"), plot=singleheatmaps[[i]])
}
