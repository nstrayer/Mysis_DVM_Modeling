library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Mysis Condition"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("rewardUnits",
                  "Mean Migration Reward:",
                  min = 0,
                  max = 1,
                  value = .8),
      sliderInput("migrationCost",
                  "Energy Cost to Migrate:",
                  min = 0,
                  max = 100,
                  value = 20),
      
      sliderInput("numOfMysis",
                  "How many mysis to simulate?",
                  min = 1,
                  max = 100,
                  value = 2)
      
#       numericInput("rewardUnits", 
#                    label = h3("Units of Reward"), 
#                    value = 0.8) 
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("foodCurve")
    )
  )
))