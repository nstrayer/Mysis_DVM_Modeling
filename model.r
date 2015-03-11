setwd("/Users/Nick/mysisModeling")
library(ggplot2)
# Thus begins the mysis model. 
# Functions that drive the model are written in the form Foo_Foo
# Variables that go into the model are writtenin camelCase. E.g. fooFoo. 

#First we are going to check for the existance of some data and if it isnt there, generate it. 

#Check for solar data
if(!file.exists("data/light_day_moon_hour.csv")){ source("dataGen/solarData.r") } 

#Check for thermocline data
if(!file.exists("data/Depth_Thermocline_Hour.csv")){ source("dataGen/thermoclineLevels.r") } 

#Mysocline data
if(!file.exists("data/mysocline_hour.csv")){ source("dataGen/depthModel.r") }


#---------------------------------------------------------------------------------------------
#Read in depth data: 
#---------------------------------------------------------------------------------------------
depthData = read.csv("data/mysocline_hour.csv")$x

#---------------------------------------------------------------------------------------------
#Class and method declarations: 
#---------------------------------------------------------------------------------------------

# testing object based r coding: 
setClass("mysis",
         representation(
           energy    = "numeric",    # The energy reserves are a numeric value
           migrating = "logical",    # If mysis is migrating is a logical value
           alive     = "logical",    # Alive still?
           depth     = "numeric"),   
         prototype(
           energy    = 0,            # The default instantiated mysis starts with zero energy...
           migrating = FALSE,        # and not migrating...
           alive     = TRUE,         # alive
           depth     = 100),         # and at the bottom.  
         )

#Set the show method, basically how we want the program to display the info about the mysis on calling. This is neccesary due to R's quirks
setMethod("show", "mysis", 
          function(object){
            if (object@alive){
              print(object@energy)
              print(object@migrating)
              print(object@depth)
            } else {
              print("dead")
            }
          })

#Making an a function to step the mysids through time, first we initialize a generic method as there is no
#pre-defined nextTime method for any other R classes. Then we set the method. 
setGeneric( "nextTime", function(object, ...){standardGeneric("nextTime")})
setMethod("nextTime","mysis", 
          function(object, foodRatio, time){       #Takes in the mysis object and the ratio of food quality at a given time. 
            
            #Lets set some constants real quick: 
            migrationRisk = 0.001      #Chance of being eaten if migrating
            stayRisk      = 0.0001     #Chance of being eaten if they stay on the bottom
            
            migrationDraw = runif(1) #random number between 0 and 1, this will be used for the migration decision
            predationDraw = runif(1) #" " to see if killed by predation
            
            #Here is the decision tree:
            if (object@alive){ #If the mysis is alive let's run the decision tree
                            
########################################################################################################################################################################
#Random migration number is less than the food ratio so the mysis migrates. E.g. MD = 0.3 < FR = 0.7 so mysis migrates. This makes 1 a guarenteed migration
  
              if (migrationDraw < foodRatio){ 
                object@migrating = TRUE
                object@depth = depthData[time] #Grab the mysocline limit at this hour 
                
                if (predationDraw > migrationRisk){ #The mysis evades predation
                  object@energy = object@energy + 10 * foodRatio #add to the energy reserves an amount scaling to the food quality
                
                } else { #Mysis is eaten
                  object@alive = FALSE
                }
                
              } else { #The mysis didn't migrate
                object@migrating = FALSE
                object@depth = 100
                
                if (predationDraw > stayRisk){ #The mysis evades predation
                  object@energy = object@energy + 10 * (1 - foodRatio) 
                  
                } else { #Mysis is eaten
                  object@alive = FALSE
                }
              }
            }
            object} #Return the mysis
          )


#---------------------------------------------------------------------------------------------
#Model testing: 
#---------------------------------------------------------------------------------------------

#Function to initialize mysids with random (uniform between 5 and 30) energies. 

mysids = NULL

#for (i in c(1)){
for (i in 1:5){
  initialenergy = sample(5:30,1)
  mysids = c(mysids, new("mysis", energy = initialenergy) )
}


migrations = NULL
hours = 1:(24*10)
for (mysid in mysids){ #loop through the mysis
  migration = NULL 
  for (i in hours){
    mysid    = nextTime(mysid, 0.8, i)
    migration = c(migration, mysid@depth)
    print(mysid)
  }
  migrations = cbind(migrations, migration) # add to the object of migrations. 
} 

migrations = cbind(migrations, hours)

migrationsDf = as.data.frame(migrations)
colnames(migrationsDf) = c("mysis1", "mysis2", "mysis3", "mysis4", "mysis5","hours")
ggplot(migrationsDf, aes(y = -mysis1, x = hours)) + geom_line() + 
  labs(title = "Mysis migration patterns for first 10 days of year", x = "Depth below surface")

