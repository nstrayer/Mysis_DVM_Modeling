library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Thermocline Model"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("MaxDepth",
                  "Maximum Depth:",
                  min = 1,
                  max = 90,
                  value = 40)
      
#       sliderInput("MaxDepth",
#                   "Maximum Depth:",
#                   min = 1,
#                   max = 90,
#                   value = 40)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))