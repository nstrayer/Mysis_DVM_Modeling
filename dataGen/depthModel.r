# See r markdown version for explanation of different parts of this script. 

setwd("/Users/Nick/mysisModeling")
depthData = read.csv("data/Depth_Thermocline_Hour.csv")$dist
lightData = read.csv("data/light_day_moon_hour.csv")$x
hours = 1:(365*24)

lightDepth = function(surfaceLight){
  
  k   = 0.3  #extinction coefficient
  I_x = 0.001 #Mysis light threshold (paper quotes between 10^-2 and 10^-4)
  
  distance = (1/k) * (log(surfaceLight) - log(I_x))
  if (distance < 0){ distance = 0 }
  return(distance)
}


isocline = NULL
for (hour in lightData){
  if (hour == 0){
    isocline = c(isocline, 0) #logs dont play nice with 0s
  } else {
    isocline = c(isocline, lightDepth(hour))
  }
}

mysocline = NULL
for (i in 1:(24*365)){
  if (depthData[i] > isocline[i]){
    mysocline = c(mysocline, depthData[i])
  } else {
    mysocline = c(mysocline, isocline[i])
  }
}


write.csv(mysocline, "data/mysocline_hour.csv", row.names=FALSE)
