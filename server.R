library(shiny)
library(ggplot2)


#Check for solar data
if(!file.exists("data/light_day_moon_hour.csv")){ source("dataGen/solarData.r") } 

#Check for thermocline data
if(!file.exists("data/Depth_Thermocline_Hour.csv")){ source("dataGen/thermoclineLevels.r") } 

#Mysocline data
if(!file.exists("data/mysocline_hour.csv")){ source("dataGen/depthModel.r") }

#Mysocline data
if(!file.exists("data/FoodAvail_Hour.csv")){ source("dataGen/foodAvailability.r") }

#Read in the data now. 
depthData = read.csv("data/mysocline_hour.csv")$x
foodCurve = read.csv("data/FoodAvail_hour.csv")
foodAvail = foodCurve$foodAvail
foodVar   = foodCurve$variability



#########################################################################################################################################
#Define the class and methods
###################################################################################################################################################

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

#Set the show method, basically how we want the program to display the info about the mysis on calling. 
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

#########################################################################################################################################
# Migration Probability curve: 
###################################################################################################################################################
migrationProb = function(condition){ #I am choosing to leave the random roll outside of script for continuity, could be changed
  m = 120 #value of curve midpoint
  k = 0.03 #steepness of curve
  x = condition 
  
  dist = 1/(1 + exp(-k* (x - m)))   
  return(1 - dist)
}





# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

  output$foodCurve <- renderPlot({
        
    
    
    
    rewardUnits = input$rewardUnits
    
    setGeneric( "nextTime", function(object, ...){standardGeneric("nextTime")})
    setMethod("nextTime","mysis", 
              function(object, foodAvail, foodVar, time){       #Takes in the mysis object and the ratio of food quality at a given time. 
                
                
                #Run the draws: 
                migrationDraw   = runif(1) #random number between 0 and 1, this will be used for the migration decision
                migrationDraw_2 = runif(1) #draw for second migration decision, this time compared to logistic curve
                predationDraw   = runif(1) #" " to see if killed by predation
                
                #Lets set some constants real quick: 
                migrationCost = input$migrationCost       #How many energy units the mysis use up migrating
                migrationRisk = 0.0001   #Chance of being eaten if migrating
                stayRisk      = 0.00001  #Chance of being eaten if they stay on the bottom
                
                #Energy rewards:
                
                migrationReward = rnorm(1,rewardUnits, foodVar)
                stayReward      = rnorm(1,(rewardUnits * ( 1 - foodAvail)), foodVar) 
                #this makes the rewards responsive to conditions
                
                sunset  = 18 #hardcode sunset, fill this with real data later. 
                sunrise = 7
                #conditionCurve = 0.95 #hardcoded condition curve value, for debugging. 
                conditionCurve = migrationProb(object@energy)
                
                
                if (object@energy <= 0){ #did the mysis starve?
                  object@alive = FALSE
                }     
                
                #if the mysis is in good condition use standard migration chance, if bad use 1 - chance
                if ((time %% 24 == sunset + 1)&&(object@alive)){
                  
                  if (migrationDraw > foodAvail) {
                    object@migrating = migrationDraw_2 > conditionCurve 
                    object@energy = object@energy - migrationCost 
                  } else {
                    object@migrating = FALSE
                  }
                  
                } else if (time %% 24 == sunrise){ #bring them back down at sunrise. 
                  object@migrating = FALSE
                }    
                
                
                
                #Here is the decision tree:
                if (object@alive){ #If the mysis is alive let's run the decision tree
                  
                  if (object@migrating){ 
                    object@depth = depthData[time] #Grab the mysocline limit at this hour 
                    
                    if (predationDraw > migrationRisk){ #The mysis evades predation
                      object@energy = object@energy + migrationReward 
                      
                    } else { #Mysis is eaten
                      object@alive = FALSE
                    }
                    
                  } else { #The mysis didn't migrate
                    
                    object@depth = 100
                    
                    if (predationDraw > stayRisk){ #The mysis evades predation
                      object@energy = object@energy +  stayReward
                      
                    } else { #Mysis is eaten
                      object@alive = FALSE
                    }
                  }
                }
                object} #Return the mysis
    )
    
    
#########################################################################################################################################
# End Next Time function

#Initialize the mysis
###################################################################################################################################################
mysids = NULL
numOfMysids = input$numOfMysis

for (i in 1:numOfMysids){
  initialenergy = rnorm(1,150,25) #draw initial energy from normal dist centered at 30 with stdev of 5. 
  mysids = c(mysids, new("mysis", energy = initialenergy) )
}

#########################################################################################################################################
# Now run them through the ringer
###################################################################################################################################################

migrations = NULL
hours = 1:(24*365) #150 days
for (mysid in mysids){ #loop through the mysis
  migration = NULL 
  conditions = NULL
  for (i in hours){
    
    mysid    = nextTime(mysid, foodAvail[i], foodVar[i] , i)
    migration = c(migration, mysid@depth)
    conditions = c(conditions, mysid@energy)
  }
  migrations = cbind(migrations, migration) # add to the object of migrations. 
} 
    
  
# migrations = cbind(migrations, hours)
# 
# migrationsDf = as.data.frame(migrations)
# colnames(migrationsDf) = c("mysis1", "mysis2", "mysis3", "mysis4", "mysis5","hours")
# ggplot(migrationsDf, aes(y = -mysis1, x = hours)) + geom_line() + 
#   labs(title = "Mysis migration patterns for first 100 days of year", y = "Depth below surface")
#     

conditions_df = as.data.frame(cbind(conditions, hours))

ggplot(conditions_df, aes(y = conditions, x = hours)) + geom_line() +geom_smooth() + 
  labs(title = "Mysis condition over year", y = "energy units")
  })
})
