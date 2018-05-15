library(crul)
library(xml2)
library(stringr)
library(dplyr)
library(leaflet)
library(htmltools)
library(stringi)

source("each_campground.R")
source("top_level_campground.R")
source("natforesturls.R")
source("helpers.R")

gp <- top_level_campground(url = gifford_pinchot) # FIXME
gp <- clean_categories(gp)
mh <- top_level_campground(mthood)
mh <- clean_categories(mh)
wm <- top_level_campground(url = williamette)
wm <- clean_categories(wm)
oc <- top_level_campground(ochoco)
oc <- clean_categories(oc)
ss <- top_level_campground(siuslaw)
ss <- clean_categories(ss)
#uq <- top_level_campground(umpqua) # FIXME
de <- top_level_campground(deschutes)
de <- clean_categories(de)
rs <- top_level_campground(rogue_siskiyou)
rs <- clean_categories(rs)

# map
tp <- de

palrest <- colorFactor(palette = 'RdYlBu', domain = tp$restroom2)
palwat <- colorFactor(palette = 'RdYlBu', domain = tp$water2)
leaflet(data = tp) %>% 
  addProviderTiles("Stamen.Terrain") %>% 
  leaflet::addCircles(
    lng = tp$lon, 
    lat = tp$lat, 
    opacity = 1,
    # color = ~palrest(tp$restroom2),
    color = ~palwat(tp$water2),
    # radius = tp$no_sites/10,
    radius = ~tp$no_sites,
    popup = ~htmlEscape(name)
  ) %>% 
  # addLegend(pal = palrest, values = ~restroom2, opacity = 1)
  addLegend(pal = palwat, values = ~water2, opacity = 1)
