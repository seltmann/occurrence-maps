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

occurrence_filtered <- read.csv("occur2.csv")

copr_boundary <- st_read("COPR_Boundary_2010/COPR_boundary2010.shp")

#Lets organize all of them into seperate data sets while we're at it. 






###This marks the end of loading in the necessary data for this app, 

ui <- fluidPage(
    titlePanel("Create a Distribution Map"),
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput(inputId = "selected_order",
                        label = "select a order",
                        choices = c("Amphipoda" = "Amphipoda", "Araneae" = "Araneae", "Archaeognatha" = "Archaeognatha", "Coleoptera" = "Coleoptera", "Decapoda" = "Decapoda", "Dermaptera" = "Dermaptera", "Diptera" = "Diptera", "Ephemeroptera" = "Ephemeroptera", "Hemiptera" = "Hemiptera", "Hymenoptera" = "Hymenoptera", "Isopoda" = "Isopoda", "Lepidoptera" = "Lepidoptera", "Odonata" = "Odonata", "Orthoptera" = "Orthoptera", "Pedunculata" = "Pedunculata", "Psocodea" = "Psocodea", "Sessilia" = "Sessilia"),
                        selected = c("Amphipoda", "Araneae", "Archaeognatha", "Coleoptera", "Decapoda", "Dermaptera", "Diptera", "Ephemeroptera", "Hemiptera", "Hymenoptera", "Isopoda", "Lepidoptera", "Odonata", "Orthoptera", "Pedunculata", "Psocodea", "Sessilia")
                         )
        ),
        mainPanel(
            plotOutput("myplot")
        )
    )
)


server <- function(input, output) {
    current_order <- reactive({
        req(input$selected_order)
        filter(occurrence_filtered, geometry %in% input$selected_order) 
        })
    
    output$myplot <- renderPlot({
        ggplot() +
            geom_sf(data = current_order(), mapping = aes(x = lon, y = lat)) +
            geom_sf(data = copr_boundary, fill = "grey", color = "black") +
            
            labs( x = "Longitude", y = "Latitude") +
            theme_gray() +
            theme(legend.key.size = unit(0.5, "cm"), 
                  axis.text = element_text(size = 7), 
            ) 
    })
   
       
                        
                        
        
    
}

# Run the application 
shinyApp(ui = ui, server = server)

