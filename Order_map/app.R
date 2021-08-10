#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rsconnect)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Coal Oil Point Occurrence Data"),

    # Sidebar with a slider input for number of bins 
    checkboxGroupInput(inputId = "order", label = "choose taxonomic order"),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("order_plot")
        )
    )


# Define server logic required to draw a histogram
server <- function(input, output) {

    output$order_plot <- renderPlot({
        # generate bins based on input$bins from ui.R
        order_plot <- ggplot() +
            geom_sf(data = copr_boundary_2020, fill = "grey", color = "black") +
            geom_sf(occur_sf_order_new_subset, mapping = aes(geometry = geometry, color = order,)) +
            ggtitle("Distribution of identified organisms within Coal Oil Point") +
            labs( x = "Longitude", y = "Latitude") +
            theme_gray() +
            theme(legend.key.size = unit(0.5, "cm"), 
                  axis.text = element_text(size = 7), 
            )
        order_plot
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
