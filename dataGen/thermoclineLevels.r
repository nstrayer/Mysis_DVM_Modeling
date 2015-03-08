#Script to generate light levels for mysis dvm model. 
thermoclineDist = function(t){
  maxThermDepth = 40
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

write.csv(data, "/Users/Nick/mysisModeling/data/Depth_Thermocline_Hour.csv", row.names=FALSE)
