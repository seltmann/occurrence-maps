#This is the leaflet version of the app. It is adapted from the ecoforecast tutorial.
#https://www.youtube.com/watch?v=f2sBa69kq3s
library(shiny)
library(leaflet)
library(raster)
library(leaflet.extras)
library(shinyWidgets)
library(sf)
library(rgdal)

specimen_data <- read.delim(file="occurrence.txt",header=TRUE)
specimen_df <- st_as_sf(specimen_data, coords = c('decimalLongitude', 'decimalLatitude'), crs = 4326)

ui <- fluidPage(
  
  #Application Title
  titlePanel("Organismal Occurrence Data Explorer"),
  
  fileInput(inputId = "filemap",
            label = "Upload map. Choose shapefile",
            multiple = TRUE,
            accept = c('.shp', '.dbf', '.sbn', '.sbx', '.prj')
    
  ), #End of fileInput

  
  sidebarLayout(
    sidebarPanel(pickerInput('order.subset', label = 'Select Taxonomic Order',
                             choices = unique(specimen_df$order),
                             selected = 'Hymenoptera', multiple = T, options = list(`action-box` = TRUE)
    ), #Close pickerInput1
    pickerInput('family.subset', label = 'Select Taxonomic Family',
                choices = unique(specimen_df$family),
                multiple = T, options = list(`action-box` = TRUE)
    ), #Close pickerInput2
    pickerInput('genus.subset', label = 'Select Taxonomic Genus',
                choices = unique(specimen_df$genus),
                multiple = T, options = list(`action-box` = TRUE)
    ), #Close pickerInput3
    pickerInput('species.subset', label = 'Select Taxonomic Species',
                choices = unique(specimen_df$specificEpithet),
                multiple = T, options = list(`action-box` = TRUE)
    ), #Close pickerInput4
    
    ), #Close sidebarPanel
    
    mainPanel(leafletOutput("map"))
    
  ) #Close sidebarLayout
  
) #Close fluidPage

server <- function(input, output) {
  
  data <- reactive({
    req(input$filedata)
    read.csv(input$filedata$datapath)
  })
  
  map <- reactive({
    req(input$filemap)
    
    # shpdf is a data.frame with the name, size, type and
    # datapath of the uploaded files
    shpdf <- input$filemap
    
    # The files are uploaded with names
    # 0.dbf, 1.prj, 2.shp, 3.xml, 4.shx
    # (path/names are in column datapath)
    # We need to rename the files with the actual names:
    # fe_2007_39_county.dbf, etc.
    # (these are in column name)
    
    # Name of the temporary directory where files are uploaded
    tempdirname <- dirname(shpdf$datapath[1])
    
    # Rename files
    for (i in 1:nrow(shpdf)) {
      file.rename(
        shpdf$datapath[i],
        paste0(tempdirname, "/", shpdf$name[i])
      )
    }
    
    # Now we read the shapefile with readOGR() of rgdal package
    # passing the name of the file with .shp extension.
    
    # We use the function grep() to search the pattern "*.shp$"
    # within each element of the character vector shpdf$name.
    # grep(pattern="*.shp$", shpdf$name)
    # ($ at the end denote files that finish with .shp,
    # not only that contain .shp)
    map <- read_sf(paste(tempdirname,
                         shpdf$name[grep(pattern = "*.shp$", shpdf$name)],
                         sep = "/"
    )) %>% sf::st_transform('+proj=longlat +datum=WGS84')
    map
  })
  ### Make reactive data by ID (from selection in sidebar)
  pres.dat.sel <- reactive({ ## open reactive expression
    if(!is.null(input$order.subset)){
      data.subset <- specimen_df[specimen_df$order %in% input$order.subset, ]
    }
    if(!is.null(input$family.subset)){
      data.subset <- specimen_df[specimen_df$family %in% input$family.subset,]
    }
    if(!is.null(input$genus.subset)){
      data.subset <- specimen_df[specimen_df$genus %in% input$genus.subset,]
    }
    if(!is.null(input$species.subset)){
      data.subset <- specimen_df[specimen_df$specificEpithet %in% input$species.subset,]
    }
    return(data.subset)
  })
  
  
  
  
  output$map <- renderLeaflet({ ## begin rendering leaflet and store as 'map' in server output
    leaflet() %>% addProviderTiles(providers$Esri.NatGeoWorldMap)  %>%
      addPolygons(data = map()) %>% 
      addCircleMarkers(data = pres.dat.sel(), color = ~order) %>% ## add circle markers with color
      addScaleBar()
  }) ## close map
  
} #close server

shinyApp(ui = ui, server = server) ## Run the app locally