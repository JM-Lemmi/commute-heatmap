# Julian Lemmerich
# scraping Gemeinden and Geocoordinates from Wikipedia
# inspired by https://github.com/JM-Lemmi/tuda-ws20-ccl2/blob/main/scrape.r

library(rvest)
library(sp)
library(stringi)

# set variables here for different page!
page <- "https://de.wikipedia.org/wiki/Liste_der_Gemeinden_in_Baden-W%C3%BCrttemberg_nach_Amtlichen_Gemeindeschl%C3%BCsseln" # Wikipedia Page with the List
css <- "h4+ ul ul a:nth-child(1)" # selector for Town-Names. With Selector Gadget

# scraping towns
html <- read_html(page)                  # read html from page
elements <- html_nodes(html, css = css)  # Gewuenschte Elemente bestimmen
linklist.short <- html_attr(elements, "href")   # attrs, damit das href element entnommen werden kann
#die href elemente sind ohne FQDN, so it has to be added manually
linklist.long <- c()
for (l in linklist.short) {
    linklist.long <- c(linklist.long, paste("https://de.wikipedia.org", l, sep="")) #entnimmt das href aus jedem element udn fügt es mit der domain zusammen
}

# scraping coordinates
coordinates <- list()
for (t in linklist.long) {
    html <- read_html(t)
    element <- html_nodes(html, css = "#coordinates .text")
    coords.dms <- html_text(element)
    coords.dms <- strsplit(coords.dms, ", ")[[1]]
    
    # this is a horrible conversion path, but at least it works...
    lat <- gsub(fixed = TRUE, "\U2032", "m", coords.dms[1]) # this is a weird apostrophe! UTF8 probaby U+2032. doesnt work with char2dms
    lat <- gsub(fixed = TRUE, "\U00B0", "d", lat) #sonderzeichen mag der wohl einfach nicht
    lat <- stri_enc_toascii(lat)
    lat <- gsub(fixed = TRUE, "\032", "", lat)
    
    long <- gsub(fixed = TRUE, "\U2032", "m", coords.dms[2])
    long <- gsub(fixed = TRUE, "\U00B0", "d", long)
    long <- stri_enc_toascii(long)
    long <- gsub(fixed = TRUE, "\032", "", long)
    
    lat_d <- char2dms(lat, chd="d", chm="m") %>% as.numeric()
    long_d <- char2dms(long, chd="d", chm="m") %>% as.numeric()
    
    coordinates <- append(coordinates, list(c(lat_d, long_d)))
}

borders <- scan(file = "./data/borders.txt", what = numeric(), sep = ",")

origins <- list()
for (t in coordinates) {
  if ((borders[2] < t[1]) & (t[1] < borders[4])) {
    if ((borders[1] < t[2]) & (t[2] < borders[3])) {
      origins <- append(origins, list(t)) 
    }
  }
}

origins.df <- as.data.frame(do.call(rbind, origins)) #convert to dataframe
write.table(origins.df, sep=",",  col.names=FALSE, row.names=FALSE, file="./data/origins.csv") #save to data/origins.csv
