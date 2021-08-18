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

###Loading the necessary data for this app

occurrence_filtered <- read.csv("occur.csv")

copr_boundary <- st_read("COPR_Boundary_2010/COPR_boundary2010.shp")

###This marks the end of loading in the necessary data for this app

ui <- fluidPage(
    
    # Application title
    titlePanel("Coal Oil Point Occurrence Data"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Create maps that plot the location of identified organisms in Coal Oil Point Reserve"), 
    checkboxGroupInput(inputId = "Order",
                       label = "Choose Taxonomic Order:",
                       choices = c("Amphipoda", "Araneae", "Archaeognatha", "Coleoptera", "Decapoda", "Dermaptera", "Diptera", "Ephemeroptera", "Hemiptera", "Hymenoptera", "Isopoda", "Lepidoptera", "Odonata", "Orthoptera", "Pedunculata", "Psocodea", "Sessilia"),
                       selected = "data_hymenoptera"), 
        ),
    
    # Show a plot of the generated distribution
    mainPanel(
        plotOutput("Order")
    )
) 
)


server <- function(input, output) {
    
    output$Order <- renderPlot({
        # generate bins based on input$bins from ui.R
         ggplot() +
            geom_sf(data = copr_boundary, fill = "grey", color = "black") +
            geom_sf(occurrence_filtered, mapping = aes(geometry = geometry, color = order,)) +
            ggtitle("Distribution of identified organisms within Coal Oil Point") +
            labs( x = "Longitude", y = "Latitude") +
            theme_gray() +
            theme(legend.key.size = unit(0.5, "cm"), 
                  axis.text = element_text(size = 7), 
            )
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

