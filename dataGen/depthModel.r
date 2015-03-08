setwd("/Users/Nick/mysisModeling")
#This script contains the model for determining the extent of migration. 
#Be warned that it spits out lots of files and is meant to be run piece by piece (or not, but youll muck up your directory)

#Let's bring in the thermocline depth data
#---------------------------------------------------------------------------------------------
#Bringing in outside data: 
#---------------------------------------------------------------------------------------------
depthData = read.csv("data/Depth_Thermocline_Hour.csv")$dist

#plot(depthData) #Just check to make sure the data is in properly. 

#---------------------------------------------------------------------------------------------
#Depth of light threshold function: 
#See brainstorm.pdf for details
#---------------------------------------------------------------------------------------------
lightDepth = function(surfaceLight){
  
  #First we will set constants. These will most likely be toggled.
  k   = 0.3  #extinction coefficient
  I_x = 0.001 #Mysis light threshold (paper quotes between 10^-2 and 10^-4)
  
  distance = (1/k) * (log(surfaceLight) - log(I_x))
  return(distance)
}

# 
# #Days vector for a year
# days = 1:365
# 
# #Nightime light level in lux
# lightLevel = NULL
# 
# for (day in days){
#   cyclePoint = day %% 27
#   lightLevel = c(lightLevel, 0.5 * cos((1/27)* 2*pi * cyclePoint ) + .5)
# }

#
#Bring in data from solarData.r! 
#

lightData = read.csv("data/light_day_moon_hour.csv")$x
hours = 1:(365*24)
  
  #Check to see if this is functional
plot(hours, lightData, type = "l",
       main = "Light Levels at Midnight (Moon Cycle)",
       xlab = "Day of Year",
       ylab = "Light Level in Lumens")
  axis(side = 1)
  axis(side = 1, col = "white", tcl = 0)
  axis(side = 2)
  axis(side = 2, col = "white", tcl = 0)


#Now we will run our light depth function over this: 
isocline = NULL
for (hour in lightData){
  if (hour == 0){
    isocline = c(isocline, 0) #logs dont play nice with 0s
  } else {
    isocline = c(isocline, lightDepth(hour))
  }
}
#Check to see if this is functional, ggplot2 style. 

isoclineDf = as.data.frame(cbind(hours, isocline))
ggplot(isoclineDf, aes(x = hours, y = -isocline)) + geom_line()

#old style. 
# plot(-isocline, type = "l",
#                 ylab = "Depth of Isocline",
#                 xlab = "Hour")
# axis(side = 1)
# axis(side = 1, col = "white", tcl = 0)
# axis(side = 2)
# axis(side = 2, col = "white", tcl = 0)


#Now that we like the data let's save it for later consumption.
#write.csv(isocline, "data/Depth_MoonLight_Day.csv", row.names=FALSE)


#Now let's grab some of our depth data real quick: 
smallDepthData = NULL
for (i in seq(1, 24*365, 24)){
  smallDepthData = c(smallDepthData, depthData[i])
}

depthLimit = NULL
for (i in 1:365){
  if (smallDepthData[i] > isocline[i]){
    depthLimit = c(depthLimit, smallDepthData[i])
  } else {
    depthLimit = c(depthLimit, isocline[i])
  }
}

write.csv(depthLimit, "data/Depth_combined_hour.csv", row.names=FALSE)

#plot it!
plot(days, -depthLimit , type = "l", ylim=c(-100,10),
     main = "Mysis Migration Threshold from Surface",
     ylab = "Depth from Surface", 
     xlab = "Day of Year")
#lines(days, -isocline)
axis(side = 1, at = c(0,50,100,150,200,250,300,350))
axis(side = 1, col = "white", tcl = 0,at = c(0,50,100,150,200,250,300,350))
axis(side = 2)
axis(side = 2, col = "white", tcl = 0)
#polygon(c(-15,-15,380,380),c(-120,0,0,-120),col=rgb(0.1, .5, .85,0.3))


