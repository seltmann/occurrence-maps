#This is the leaflet version of the app. It is adapted from the ecoforecast tutorial.
#https://www.youtube.com/watch?v=f2sBa69kq3s
library(shiny)
library(leaflet)
library(raster)
library(leaflet.extras)
library(shinyWidgets)
library(sf)

specimen_data <- read.delim(file="occurrence.txt",header=TRUE)
specimen_data_w_crs <- st_as_sf(specimen_data, coords = c('decimalLongitude', 'decimalLatitude'), crs = 4326)

ui <- fluidPage(
  
  # Application title
  titlePanel("Map for exploring"),
  
  sidebarLayout( ## add second for picking data
    sidebarPanel(pickerInput('taxa', label = 'Select a Taxonomic Order', ## Creating the menu
                             choices = unique(specimen_data_w_crs$order), ## Specifying possible choices
                             selected = 'Hymenoptera',multiple = T,options = list(`actions-box` = TRUE))), ## adding more menu options
                 
                 #sliderInput("buff_distance", "Buffer distance", ## Add slider input and action button in step 3
                             #min = 0, max = 10000, value = 400), ## Set min, max, and default values
                 #actionButton("create_buffer", "Create buffer")), ## Add an action button for creating buffer
    
    mainPanel(leafletOutput("map")) ## Basic map for user to explore
  ) # Close sidebarLayout
) ## close ui


server <- function(input, output) {
  
  ### Make reactive data by ID (from selection in sidebar)
  pres.dat.sel <- reactive({ ## open reactive expression
    data.subset <- specimen_data_w_crs[specimen_data_w_crs$order == input$taxa, ]  #filters by data source
    return(data.subset)
  })
  
  pres.dat.buffer <- eventReactive(list(pres.dat.sel(), input$create_buffer), { ## New reactive expression to execute buffer around points
    pres.buff <- raster::buffer(pres.dat.sel(), input$buff_distance) ## The buffer function acting on user inputs
    return(pres.buff) ## Return the buffer (spatial polygons) object
  })
  
  output$map <- renderLeaflet({ ## begin rendering leaflet and store as 'map' in server output
    leaflet() %>% addProviderTiles(providers$Esri.NatGeoWorldMap)  %>% ## Add basemap
      addCircleMarkers(data = pres.dat.sel(), color = ~order) %>% ## add circle markers with color
      addScaleBar() %>%  #add dynamic scale bar
      addLegend(colors = c("Green","Blue"), labels = c("Camera","Scat"), ## Add manual legend
                title = "Data Source") ## Title it
  }) ## close map
  
  observe({ ## Observe buffer creation and add it to map
    req(input$create_buffer)  # to prevent error when no buffer has been created
    req(nrow(pres.dat.sel())>0) # to prevent error when no presence data
    leafletProxy("map") %>%  ## Proxy to send commands to a map that is already rendered
      clearShapes() %>% ## Clear any previous buffer lines before adding new
      addPolylines(data =pres.dat.buffer(), col='teal' ) ## Add the buffer lines to map
  })
  
} ## close server

shinyApp(ui = ui, server = server) ## Run the app locally