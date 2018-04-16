library(crul)
library(xml2)
library(stringr)
library(dplyr)

source("each_campground.R")
source("top_level_campground.R")
source("natforesturls.R")

gp <- top_level_campground(gifford_pinchot)
mh <- top_level_campground(mthood)
wm <- top_level_campground(url = williamette) # FIXME!!!
# oc <- top_level_campground(ochoco)

# map
library(leaflet)
library(htmltools)

tp <- mh

palrest <- colorFactor(palette = 'Dark2', domain = tp$Restroom)
palwat <- colorFactor(palette = 'Dark2', domain = tp$Water)
leaflet(data = tp) %>% 
  addProviderTiles("Stamen.Terrain") %>% 
  leaflet::addCircles(
    lng = tp$lon, 
    lat = tp$lat, 
    opacity = 1,
    color = ~palrest(tp$Restroom),
    # color = ~palwat(tp$Water),
    # radius = tp$no_sites/10,
    popup = ~htmlEscape(name)
  ) %>% 
  addLegend(pal = palrest, values = ~Restroom, opacity = 1)
  # addLegend(pal = palwat, values = ~Water, opacity = 1)
