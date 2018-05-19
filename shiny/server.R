library(readr)
library(leaflet)
library(htmltools)
library(dplyr)

paths <- list(
  gifford_pinchot = "data/gifford_pinchot.csv",
  mthood = "data/mthood.csv",
  williamette = "data/williamette.csv",
  ochoco = "data/ochoco.csv", 
  siuslaw = "data/siuslaw.csv",
  # umpqua = "data/ump",
  deschutes = "data/deschutes.csv",
  rogue_siskiyou = "data/rogue_siskiyou.csv"
)

server <- function(input, output, session) {
  
  campingData <- reactive({
    x <- input$Forests
    df <- dplyr::bind_rows(lapply(x, function(z) {
      suppressMessages(readr::read_csv(paths[[z]]))
    }))
    flush <- input$flush
    if (flush) {
      df <- dplyr::filter(df, grepl("flush", restroom2))
    }
    water <- input$water
    if (water) {
      df <- dplyr::filter(df, grepl("yes|potable", water2))
    }
    reservations <- input$reservations
    if (reservations) {
      df <- dplyr::filter(df, grepl("Reserve online", Reservations))
    }
    
    df
  })
  
  # campingData <- reactive({
  #   x <- input$flush
  #   dplyr::filter(campingData(), grepl("flush", restroom2))
  # })
  
  output$map <- renderLeaflet({
    dat <- campingData()
    palrest <- colorFactor(palette = 'RdYlBu', domain = dat$restroom2)
    palwat <- colorFactor(palette = 'RdYlBu', domain = dat$water2)
    leaflet(data = dat) %>% 
      addProviderTiles("OpenStreetMap.BlackAndWhite") %>% 
      leaflet::addCircles(
        lng = dat$lon,
        lat = dat$lat,
        opacity = 0.6,
        # color = ~palrest(dat$restroom2),
        # color = ~palwat(dat$water2),
        weight = 9,
        # radius = dat$no_sites/10,
        # radius = ~dat$no_sites,
        popup = 
          ~sprintf("%s<br>no. sites: %s<br><a href=\"%s\" target=\"_blank\">website</a><br><a href=\"https://www.recreation.gov/\" target=\"_blank\">Reservation</a>", name, no_sites, url)
      )
      # addLegend(pal = palrest, values = ~restroom2, opacity = 1, position = "bottomright")
      # addLegend(pal = palwat, values = ~water2, opacity = 1, position = "bottomright")
  })
}
