library(shiny)
library(leaflet)

campgrounds <- c("gifford_pinchot", "mthood", "williamette", "ochoco", 
                 "siuslaw", "deschutes", "rogue_siskiyou")

# ui <- fluidPage(
#   titlePanel("camping!"),
#   
#   sidebarLayout(
#     sidebarPanel(
#       selectInput(inputId = "Forests", choices = campgrounds, selected = "siuslaw", multiple = FALSE, label = "US National Forest")
#     ),
#     mainPanel(
#       leafletOutput("map")
#     )
#   )
# )

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(
    top = 10, right = 150,
    selectInput(inputId = "Forests", choices = campgrounds, selected = "siuslaw", 
                multiple = TRUE, label = "US National Forest"),
    checkboxInput(inputId = "flush", label = "Flush only?", value = FALSE),
    checkboxInput(inputId = "water", label = "Potable water?", value = FALSE),
    checkboxInput(inputId = "reservations", label = "Reservations available?", value = FALSE)
  )
)
