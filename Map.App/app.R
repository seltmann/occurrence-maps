#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2) #library for visualization and plotting.
library(sf) #Spatial objects package, very useful for vector data types
library(raster) #Spatial object package for raster type data
library(rgdal) #Spatial objects
library(dplyr) #Cleaning and data wrangling 
library(tidyr) #Very large package for data organization
library(plotly) #Makes ggplots interactive 
library(tmap) #Another interactive map package
library(leaflet)

###Loading the necessary data for this app

occurrence_filtered <- st_read("occur5.csv", options = "GEOM_POSSIBLE_NAMES=WKT")

occurrence_filtered <- st_set_crs(occurrence_filtered, "+proj=lcc +lat_0=33.5 +lon_0=-118 +lat_1=35.4666666666667
+lat_2=34.0333333333333 +x_0=2000000.0001016 +y_0=500000.0001016
+datum=NAD83 +units=us-ft +no_defs")

cols <- topo.colors(nrow(occurrence_filtered))

copr_boundary <- st_read("COPR_Boundary_2010/COPR_boundary2010.shp")

#Lets organize all of them into seperate data sets while we're at it. 






###This marks the end of loading in the necessary data for this app, 

ui <- fluidPage(
    titlePanel("Create a Organismal Distribution Map at Coal Oil Point Reserve"),
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput(inputId = "selected_order",
                        label = "select a taxonomic order",
                        choices = c("Amphipoda" = "Amphipoda", "Araneae" = "Araneae", "Archaeognatha" = "Archaeognatha", "Coleoptera" = "Coleoptera", "Decapoda" = "Decapoda", "Dermaptera" = "Dermaptera", "Diptera" = "Diptera", "Ephemeroptera" = "Ephemeroptera", "Hemiptera" = "Hemiptera", "Hymenoptera" = "Hymenoptera", "Isopoda" = "Isopoda", "Lepidoptera" = "Lepidoptera", "Odonata" = "Odonata", "Orthoptera" = "Orthoptera", "Pedunculata" = "Pedunculata", "Psocodea" = "Psocodea", "Sessilia" = "Sessilia"),
                        selected = "Hymenoptera"),
            downloadButton("download", "Download .csv")
        ),
        
        mainPanel(
            plotlyOutput("myplot")
        )
    )
)


server <- function(input, output) {
    current_order <- reactive({
        req(input$selected_order)
        #occurrence_filtered %>% 
        filter(occurrence_filtered, order %in% input$selected_order)
        })
    
    output$myplot <- renderPlotly({
       p <- ggplot() +
            
            geom_sf(data = copr_boundary) +
            geom_sf(data = current_order(), mapping = aes(geometry = geometry, color = order, count = count) ) +
            
            labs( x = "Longitude", y = "Latitude") +
            theme_gray() +
            theme(legend.key.size = unit(0.5, "cm"), 
                  axis.text = element_text(size = 7), 
            )  +
           scale_colour_manual(limits = occurrence_filtered$order, values = cols)
       ggplotly(p)
    })
    
    data <- reactive({
        out <- current_order() 
    })
    
    output$download <- downloadHandler(
        filename = function() {
            paste0(input$occurrence_filtered, ".csv", sep = "")
        },
        content = function(file) {
            write.csv(occurrence_filtered, file)
        }
    )
       
                        
                        
        
    
}

# Run the application 
shinyApp(ui = ui, server = server)

