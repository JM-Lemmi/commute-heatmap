library(ggplot2)
library(ggmap)
library(RColorBrewer)
library(MBA)
library(fields)

coords.data <- read.csv(file="./data/dataset.csv")
coords.frame <- data.frame(coords.data[[1]], coords.data[[2]], coords.data[[3]])

coords.frame=coords.frame[ order(coords.frame[,1], coords.frame[,2],coords.frame[,3]), ]
mba.int <- mba.surf(coords.frame, 300, 300, extend=T)$xyz.est
heatmap <- fields::image.plot(mba.int)

map_bounds <- c(left = 8.21097311878448, bottom = 48.839070863368256, right = 9.309013850627368, top = 49.380320282629306)
coords.map <- get_stamenmap(map_bounds, zoom = 12, maptype = "toner-lite")

coords.map <- ggmap(coords.map, extent="device", legend="none")
coords.map <- coords.map + heatmap

coords.map <- coords.map + theme_bw()
ggsave(filename="./data/coords.png")