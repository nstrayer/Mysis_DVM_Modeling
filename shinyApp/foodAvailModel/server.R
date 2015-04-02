library(shiny)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$foodCurve <- renderPlot({

#     
#     min     = input$min #minimum food availability value
#     max     = input$max #max 
#     highDay = input$highDay*24 #Number of days into the year that the max food availability is (226 is aug 15)
#     august  = 5856 #hours into the year
#     
#     
#     #Now we generate the others
#     scaler    = (max - min)/2 #range divided by two
#     heightAdj = (max + min)/2 #average value
#     hours      = 1:(365*24) #Set up a hour vector to loop over
#     foodAvail = NULL  
#     
#     #Quick loop to generate the data. 
#     for (hour in hours){
#       foodAvail = c(foodAvail, scaler * cos( (1/(365*24))*2*pi * (hour - highDay)) + heightAdj)
#     }
#     
#     
#     #plot(hours,foodAvail, type = "l")
#     
#     foodAvailDf = data.frame(hours, foodAvail)
    
    source("testing.R")
    
    ggplot(foodAvailDf, aes(x = hours, y = foodAvail)) + geom_line() + 
      labs(title = "Food Availability over Year", y = "Pelagic Qual: Benthic Qual", x = "Hour of year")
  })
})
