library(shiny)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$distPlot <- renderPlot({
#     x    <- rnorm(5000)  # Old Faithful Geyser data
#     bins <- seq(min(x), max(x), length.out = input$bins + 1)
#     
#     # draw the histogram with the specified number of bins
#     hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    thermoclineDist = function(t){
      
      maxThermDepth = input$MaxDepth
      
      if (t < (2190*2)) { #Winter + Spring
        n1 = .003
        n2 = -5
        x = t 
        dist = (maxThermDepth)/(1 + exp(-(n2 + n1*x)))   
      } else { #Summer+ fall
        n1 = .005
        n2 = -8
        x = t - (2190*2)
        dist = (-maxThermDepth)/(1 + exp(-(n2 + n1*x))) + maxThermDepth
      }
      return(dist)
    }
    
    
    hours  = 0:(365*24) 
    dist = NULL
    
    for (t in hours){ dist = c(dist, thermoclineDist(t)) }
    
    data = cbind(hours, dist) # Wrap the data. 
    
    thermocline = as.data.frame(data)
    ggplot(thermocline, aes(x = hours, y = dist)) + geom_line() + 
      labs(title = "Thermocline Depth", y = "depth")
  })
})
