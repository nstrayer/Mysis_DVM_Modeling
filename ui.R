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
                  value = 0.67),
      
      sliderInput("migrationCost",
                  "Energy Cost to Migrate:",
                  min = 0,
                  max = 25,
                  value = 20),
      
      sliderInput("numOfMysids",
                  "How many mysis to simulate?",
                  min = 1,
                  max = 100,
                  value = 3)

    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("foodCurve")
    )
  )
))