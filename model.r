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


#---------------------------------------------------------------------------------------------
#Class and method declarations: 
#---------------------------------------------------------------------------------------------

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
          function(object, tempPressure){
            object@cals = object@cals - 3
            
            if(object@migrating == TRUE){ #if they migrated last itteration... 
              object@cals =  object@cals + 10 #they gain calories
              object@migrating = FALSE #They go back down
              
            } else if(object@cals < 10 && tempPressure < .5){     #if they meet migration thresholds...
              object@migrating = TRUE #initiate migration
              
            } else if (object@cals < 5){ #If they are about to starve
              object@migrating = TRUE #initiate migration
            }
            
            object}
          )


#---------------------------------------------------------------------------------------------
#Model testing: 
#---------------------------------------------------------------------------------------------
#mysids = c(new("mysis", cals = 30), new("mysis", cals = 25) )

#Function to initialize 1000 mysids with random (uniform between 5 and 30) calories. 

mysids = NULL
for (i in 1:10){
  initialCals = sample(5:30,1)
  mysids = c(mysids, new("mysis", cals = initialCals) )
}

allMigrations = NULL
migrations = NULL
counter = 1
while (counter < (365*24)){
  migrations = NULL
  for (mysis in mysids){
    mysis = nextTime(mysis, Temp_Response(counter))
    migrations = c(migrations, mysis@migrating)
    print(mysis)
  }
  allMigrations = cbind(allMigrations, migrations)
  counter = counter + 1
}

