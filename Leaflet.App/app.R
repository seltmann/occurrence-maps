#This is the leaflet version of the app. It is adapted from the ecoforecast tutorial.
#https://www.youtube.com/watch?v=f2sBa69kq3s
library(shiny)
library(leaflet)
library(raster)
library(leaflet.extras)
library(shinyWidgets)

ui <- fluidpage(#fluid page a common, nice looking layout for shiny apps
  
  #Application Title 
  titlePanel("Map for exploring"), 
  
  ##Main Page
  mainPanel(leafletOutput("map")) #Basic map for user to explore
  
  
  
  ) #Close the ui

server <- function(input, output) {
  
  output$map <- renderLeaflet({ #Begin rendering leaflet and store 'map' in server output
    leaflet() %>% addProviderTiles(providers$OpenStreetMap) ## add basemap from provider list Note:There is a large list of these we can choose from
    
  }) ## Close map
  
  
}

shinyApp(ui = ui, server = server)