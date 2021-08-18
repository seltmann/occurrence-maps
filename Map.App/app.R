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

occurrence_filtered <- read.csv("occur2.csv")

copr_boundary <- st_read("COPR_Boundary_2010/COPR_boundary2010.shp")

#Lets organize all of them into seperate data sets while we're at it. 
data_amphipoda <- occurrence_filtered %>% 
    dplyr::filter(order == "Amphipoda")

data_araneae <- occurrence_filtered %>% 
    dplyr::filter(order == "Araneae")

data_archaeognatha <- occurrence_filtered %>% 
    dplyr::filter(order == "Archaeognatha")

data_coleoptera <- occurrence_filtered %>% 
    dplyr::filter(order == "Coleoptera")

data_decapoda <- occurrence_filtered %>% 
    dplyr::filter(order == "Decapoda")

data_dermaptera <-occurrence_filtered %>% 
    dplyr::filter(order == "Dermaptera")

data_diptera <- occurrence_filtered %>% 
    dplyr::filter(order == "Diptera")

data_ephemeroptera <- occurrence_filtered %>% 
    dplyr::filter(order == "Ephemeroptera")

data_hemiptera <- occurrence_filtered %>% 
    dplyr::filter(order == "Hemiptera")

data_hymenpotera <-occurrence_filtered %>% 
    dplyr::filter(order == "Hymenoptera")

data_isopoda <- occurrence_filtered %>% 
    dplyr::filter(order == "Isopoda")

data_lepidoptera <- occurrence_filtered %>% 
    dplyr::filter(order == "Lepidoptera")

data_odonata <- occurrence_filtered %>% 
    dplyr::filter(order == "Odonata")

data_orthoptera <- occurrence_filtered %>% 
    dplyr::filter(order == "Orthoptera")

data_pedunculata <- occurrence_filtered %>% 
    dplyr::filter(order == "Pedunculata")

data_psocodea <- occurrence_filtered %>% 
    dplyr::filter(order == "Psocodea")

data_sessilia <- occurrence_filtered %>% 
    dplyr::filter(order == "Sessilia")



###This marks the end of loading in the necessary data for this app

ui <- fluidPage(
    
    # Application title
    titlePanel("Coal Oil Point Occurrence Data"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Create distribution maps of the locations of identified organisms in Coal Oil Point Reserve"), 
    checkboxGroupInput(inputId = "Order",
                       label = "Choose Taxonomic Order:",
                       choices = c("Amphipoda", "Araneae", "Archaeognatha", "Coleoptera", "Decapoda", "Dermaptera", "Diptera", "Ephemeroptera", "Hemiptera", "Hymenoptera", "Isopoda", "Lepidoptera", "Odonata", "Orthoptera", "Pedunculata", "Psocodea", "Sessilia"),
                       selected = "data_hymenoptera"), 
        ),
    
    # Show a plot of the generated distribution
    mainPanel(
        plotOutput("map")
    )
) 
)


server <- function(input, output) {
    
    output$map <- renderPlot({
        # generate bins based on input$bins from ui.R
         data <- switch(input$Order, "Amphipoda" = occurrence_filtered$data_amphipoda, 
                                     "Araneae" = occurrence_filtered$data_araneae,
                                     "Archaeognatha" = occurrence_filtered$data_archaeognatha,
                                     "Coleoptera" = occurrence_filtered$data_coleoptera,
                                     "Decapoda" = occurrence_filtered$data_decapoda,
                                     "Dermaptera" = occurrence_filtered$data_dermaptera,
                                     "Diptera" = occurrence_filtered$data_diptera,
                                     "Ephemeroptera" = occurrence_filtered$data_ephemeroptera,
                                     "Hemiptera" = occurrence_filtered$data_hemiptera,
                                     "Hymenoptera" = occurrence_filtered$data_hymenpotera,
                                     "Isopoda" = occurrence_filtered$data_isopoda,
                                     "Lepidoptera" = occurrence_filtered$data_lepidoptera,
                                     "Odonata" = occurrence_filtered$data_odonata, 
                                     "Orthoptera" = occurrence_filtered$data_orthoptera, 
                                     "Pedunculata" = occurrence_filtered$data_pedunculata,
                                     "Psocodea" = occurrence_filtered$data_psocodea,
                                     "Sessilia" = occurrence_filtered$data_sessilia)
          ggplot() +
             geom_sf(data = copr_boundary, fill = "grey", color = "black") +
             geom_sf(data = data, mapping = aes(x = lon, y = lat)) +
             labs( x = "Longitude", y = "Latitude") +
             theme_gray() +
             theme(legend.key.size = unit(0.5, "cm"), 
                   axis.text = element_text(size = 7), 
             ) 
                        
                        
                        
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

