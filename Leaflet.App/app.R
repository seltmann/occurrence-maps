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
    sidebarPanel(pickerInput('order.subset', label = 'Select a Taxonomic Order', ## Creating the menu
                             choices = unique(specimen_data_w_crs$order), ## Specifying possible choices
                             selected = 'Hymenoptera',multiple = T,options = list(`actions-box` = TRUE)), ## adding more menu options
                 
                 conditionalPanel(
                   condition = "data.subset2",
                   pickerInput('family.subset', label = "Select a Taxonomic Family",
                               choices = unique(specimen_data_w_crs$family),
                               multiple = T,options = list(`actions-box` = TRUE)),),
                 conditionalPanel(
                   condition = "data.subset2",
                   pickerInput('genus.subset', label = "Select a Taxonomic Genus",
                               choices = unique(specimen_data_w_crs$genus),
                               multiple = T,options = list(`actions-box` = TRUE)),),
                 conditionalPanel(
                   condition = "data.subset2",
                   pickerInput('species.subset', label = "Select a Taxonomic Species Epithet",
                               choices = unique(specimen_data_w_crs$specificEpithet),
                               multiple = T,options = list(`actions-box` = TRUE)),
                   
                   
                 )
                 
    ),
    mainPanel(leafletOutput("map")) ## Basic map for user to explore
  ) # Close sidebarLayout
) ## close ui


server <- function(input, output) {
  
  ### Make reactive data by ID (from selection in sidebar)
  pres.dat.sel <- reactive({ ## open reactive expression
    if(!is.null(input$order.subset)){
    data.subset <- specimen_data_w_crs[specimen_data_w_crs$order %in% input$order.subset, ]
    }
    if(!is.null(input$family.subset)){
    data.subset <- specimen_data_w_crs[specimen_data_w_crs$family %in% input$family.subset,]
    }
    if(!is.null(input$genus.subset)){
      data.subset <- specimen_data_w_crs[specimen_data_w_crs$genus %in% input$genus.subset,]
    }
    if(!is.null(input$species.subset)){
      data.subset <- specimen_data_w_crs[specimen_data_w_crs$specificEpithet %in% input$species.subset,]
    }
    return(data.subset)
  })
  
  
  
  
  output$map <- renderLeaflet({ ## begin rendering leaflet and store as 'map' in server output
    leaflet() %>% addProviderTiles(providers$Esri.NatGeoWorldMap)  %>% ## Add basemap
      addCircleMarkers(data = pres.dat.sel(), color = ~order) %>% ## add circle markers with color
      addScaleBar()
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