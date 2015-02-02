setwd("/Users/Nick/mysisModeling")
# This is a file of miscelaneous code written for the project that I may want later. 
# Better safe than sorry!


#Let's bring in the thermocline depth data
#---------------------------------------------------------------------------------------------
#Bringing in outside data: 
#---------------------------------------------------------------------------------------------


depthData = read.csv("thermoclineDepths.csv")$dist

Temp_Response  = function(thermoclineDepth){
  pressure = (-1/40)*thermoclineDepth + 1
  return(pressure)
}

#Code to test out what the response to thermocline depth function looks like
# response = c()
# for (depth in depthData){
#   response = c(response,Temp_Response(depth) )
# }
# png("thermoclineResponse.png")
# plot(0:(365*24), response)
# dev.off()



### From inside the decision tree generation 1:

# object@energy = object@energy - 3 #Just existing takes some energy out of the mysis, doing this first allows for the death of mysis. 
# 
# 
# if (object@energy < 10){ #If the reserves are very low, force risky migration
#   if (runif(1) < 0.3) { # there is a 30% chance of the mysis getting killed by predators when migrating
#     
#   }
# }
# 
# 
# if(object@migrating == TRUE){ #if they migrated last itteration... 
#   object@energy =  object@energy + 10 #they gain calories
#   object@migrating = FALSE #They go back down
#   
# } else if(object@energy < 10 && foodRatio < .5){     #if they meet migration thresholds...
#   object@migrating = TRUE #initiate migration
#   
# } else if (object@energy < 5){ #If they are about to starve
#   object@migrating = TRUE #initiate migration
# }