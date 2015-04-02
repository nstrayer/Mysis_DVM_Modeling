library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Food Availability"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("highDay",
                  "Warmest Day",
                  min = 1,
                  max = 365,
                  value = 210),
      
      sliderInput("min",
                  "Minimum Food Availability Value:",
                  min = 0,
                  max = 1,
                  value = .15),
      
      sliderInput("max",
                  "Maximum Food Availability Value:",
                  min = 0,
                  max = 1,
                  value = .95)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("foodCurve")
    )
  )
))