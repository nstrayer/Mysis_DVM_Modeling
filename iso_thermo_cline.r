setwd("/Users/Nick/mysisModeling")

# Thus begins the mysis model. 
# Functions that drive the model are written in the form Foo_Foo
# Variables that go into the model are writtenin camelCase. E.g. fooFoo. 

#Let's bring in the thermocline depth data
#---------------------------------------------------------------------------------------------
#Bringing in outside data: 
#---------------------------------------------------------------------------------------------
depthData = read.csv("thermoclineDepths.csv")$dist

plot(-depthData[seq(12, length(lightLevels), 24)], type = "l", frame.plot=T,axes=FALSE,ylim=c(-100,0),
     main = "Depth of 10 degrees Centigrade from Surface",
     xlab = "Day of Year",
     ylab = "Depth from Water Surface")
axis(side = 1, at = c(0,50,100,150,200,250,300,350))
axis(side = 1, col = "white", tcl = 0,at = c(0,50,100,150,200,250,300,350))
axis(side = 2)
axis(side = 2, col = "white", tcl = 0)


#---------------------------------------------------------------------------------------------
#Depth of light threshold function: 
#---------------------------------------------------------------------------------------------
lightDepth = function(surfaceLight){
  
  #First we will set constants. These will most likely be toggled.
  k   = 0.3  #extinction coefficient
  I_x = 0.001 #Mysis light threshold (paper quotes between 10^-2 and 10^-4)
  
  distance = (1/k) * (log(surfaceLight) - log(I_x))
  return(distance)
}

#30 day cycle
#days = 1:30
days = 1:365

#Nightime light level in lux
lightLevel = NULL

for (day in days){
  cyclePoint = day %% 27
  lightLevel = c(lightLevel, 0.5 * cos((1/27)* 2*pi * cyclePoint ) + .5)
}

#Check to see if this is functional
plot(days, lightLevel, type = "l",
     main = "Light Levels at Midnight (Moon Cycle)",
     xlab = "Day of Year",
     ylab = "Light Level in Lumens")
axis(side = 1)
axis(side = 1, col = "white", tcl = 0)
axis(side = 2)
axis(side = 2, col = "white", tcl = 0)

#Now we will run our light depth function over this: 
isocline = NULL
for (day in lightLevel){
  if (day == 0){
    isocline = c(isocline, 0) #logs dont play nice with 0s
  } else {
    isocline = c(isocline, lightDepth(day))
  }
}
#Check to see if this is functional
plot(days, isocline, type = "l")
axis(side = 1)
axis(side = 1, col = "white", tcl = 0)
axis(side = 2)
axis(side = 2, col = "white", tcl = 0)

#Now let's grab some of our depth data real quick: 
smallDepthData = NULL
for (i in seq(1,24*365, 24)){
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

suface = as.list(rep(0, 365))
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
polygon(c(-15,-15,380,380),c(-120,0,0,-120),col=rgb(0.1, .5, .85,0.3))

