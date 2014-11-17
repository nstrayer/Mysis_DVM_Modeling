setwd("/Users/Nick/mysisModeling")
# Thus begins the mysis model. 
# Functions that drive the model are written in the form Foo_Foo
# Variables that go into the model are writtenin camelCase. E.g. fooFoo. 

#Let's bring in the thermocline depth data

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

Light_Response = function(lightLevels){
}



# testing object based r coding: 
setClass("mysis",
         representation(
           cals = "numeric",
           migrating = "logical"),
         prototype(
           cals = 0,
           migrating = FALSE),
         )

#Set the show method, basically how we want the program to display the info about the mysis on calling. 
setMethod("show", "mysis", 
          function(object){
            print(object@cals)
            print(object@migrating)
          })

#Making an a function to step the mysids through time, first we initialize a generic method as there is no
#pre-defined nextTime method for any other R classes. Then we set the method. 
setGeneric( "nextTime", function(object, ...){standardGeneric("nextTime")})
setMethod("nextTime","mysis", 
          function(object, addition){
            object@cals = object@cals + addition 
            if(object@migrating == TRUE){ #if they migrated last itteration, reset them. 
              object@migrating = FALSE
            }
            if(object@cals > 200){    #if they meet migration thresholds...
              object@migrating = TRUE #initiate migration
              object@cals = 50 #reset the calorie amounts. 
            } 
            object}
          )

#while the mysis is not(!) migrating, loop.
mysis1 = new("mysis", cals = 30) #initiate a single mysis

counter = 0
while (counter < 100){
  mysis1 = nextTime(mysis1, 10)
  counter = counter + 1
  print(mysis1)
}