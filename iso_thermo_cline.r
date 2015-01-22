setwd("/Users/Nick/mysisModeling")
# Thus begins the mysis model. 
# Functions that drive the model are written in the form Foo_Foo
# Variables that go into the model are writtenin camelCase. E.g. fooFoo. 

#Let's bring in the thermocline depth data
#---------------------------------------------------------------------------------------------
#Bringing in outside data: 
#---------------------------------------------------------------------------------------------
depthData = read.csv("thermoclineDepths.csv")$dist

#---------------------------------------------------------------------------------------------
#Depth of light threshold function: 
#---------------------------------------------------------------------------------------------
lightDepth = function(surfaceLight){
  
  #First we will set constants. These will most likely be toggled.
  k   = 0.15  #extinction coefficient
  I_x = 0.01 #Mysis light threshold (paper quotes between 10^-2 and 10^-4)
  
  distance = (1/k) * (log(surfaceLight) - log(I_x))
  return(distance)
}

#30 day cycle
days = 1:30

#Nightime light level in lux
lightLevel = NULL

for (day in days){
  lightLevel = c(lightLevel, 0.5 * cos((1/30)* 2*pi * day ) + .5)
}

#Check to see if this is functional
#plot(days, lightLevel)

#Now we will run our light depth function over this: 
isocline = NULL
for (day in lightLevel){
  if (day == 0){
    isocline = c(isocline, 0) #logs dont play nice with 0s
  } else {
    isocline = c(isocline, lightDepth(day))
  }
}


#Now let's grab some of our depth data real quick: 
smallDepthData = NULL
for (i in seq(1,24*30, 24)){
  smallDepthData = c(smallDepthData, depthData[i])
}

#plot it!
plot(days, isocline, type = "l", ylab = "isocline depth", main = "Mysis light threshold")
lines(days, smallDepthData)


