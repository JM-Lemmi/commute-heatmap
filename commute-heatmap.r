
upperleft = c(49.428, 8.628)
bottomright = c(49.109, 9.277)

longlist = seq(upperleft[1], bottomright[1], -0.001)
latlist = seq(upperleft[2], bottomright[2], 0.001)

coordinates = list()

for(lat in latlist){
  for(long in longlist){
    coord = c(long, lat)
    coordinates <- append(coordinates, list(coord))
  }
}
