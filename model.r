library(ggplot2)
library(reshape2)
library(grid)
library(gridExtra)
setwd("/Users/Nick/mysisModeling") #Doesnt actually do anything in chunks.

############################################################################################################

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

############################################################################################################

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
############################################################################################################


migrationProb = function(condition){ #I am choosing to leave the random roll outside of script for continuity, could be changed
  m = 120 #value of curve midpoint
  k = 0.03 #steepness of curve
  x = condition 
  
  dist = 1/(1 + exp(-k* (x - m)))   
  return(1 - dist)
}
############################################################################################################

numOfMysids        = 200
# migrationCost    = 20       #How many energy units the mysis use up migrating
rewardUnits         = 0.65
migrationCost_list = seq(18,22,0.5)

for (migrationCost in migrationCost_list){
  
  setGeneric( "nextTime", function(object, ...){standardGeneric("nextTime")})
  setMethod("nextTime","mysis", 
            function(object, foodAvail, foodVar, time){       #Takes in the mysis object and the ratio of food quality at a given time. 
              
              #Run the draws: 
              migrationDraw   = runif(1) #random number between 0 and 1, this will be used for the migration decision
              migrationDraw_2 = runif(1) #draw for second migration decision, this time compared to logistic curve
              predationDraw   = runif(1) #" " to see if killed by predation
              #Lets set some constants real quick: 
              migrationRisk = 0  #We don't really need to simulate predation.
              stayRisk      = 0 
              #             migrationRisk = 0.0001   #Chance of being eaten if migrating
              #             stayRisk      = 0.00001  #Chance of being eaten if they stay on the bottom
              #             
              #Energy rewards:
              migrationReward = rnorm(1, (rewardUnits*(1 + foodAvail)), foodVar)
              stayReward      = migrationReward * .2
              threshold = 0.2  #Let's make sure that the benthic reward can never drop below a threshold.
              if(stayReward < threshold){
                stayReward = threshold
              }
              
              sunset  = 18 #hardcode sunset, fill this with real data later. 
              sunrise = 7
              conditionCurve = migrationProb(object@energy)
              
              if (object@energy <= 0){ #did the mysis starve?
                object@alive = FALSE
                object@energy = 0
              }     
              #if the mysis is in good condition use standard migration chance, if bad use 1 - chance
              if ((time %% 24 == sunset + 1)&&(object@alive)){
                if (migrationDraw < foodAvail) {
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
  ############################################################################################################
  
  mysids = NULL
  mysisNames = paste("mysis",(seq(1,numOfMysids)), sep = "")
  
  for (i in 1:numOfMysids){
    initialenergy = rnorm(1,150,25) #draw initial energy from normal dist centered at 30 with stdev of 5. 
    mysids = c(mysids, new("mysis", energy = initialenergy) )
  }
  ############################################################################################################
  
  migrations = NULL #Initialize some dataframes to keep track of the migrations and conditions values for the mysids. 
  conditions = NULL
  alive      = NULL
  hours = 1:(24*365) #150 days
  for (mysid in mysids){ #loop through the mysis
    migration = NULL  
    condition = NULL
    for (i in hours){
      mysid    = nextTime(mysid, foodAvail[i], foodVar[i] , i)
      migration = c(migration, mysid@depth)
      condition = c(condition, mysid@energy)
      if (i == length(hours)) { alive = c(alive, mysid@alive)}
    }
    migrations = cbind(migrations, migration) # add to the object of migrations. 
    conditions = cbind(conditions, condition)
  } 
  
  ############################################################################################################
  
  migrations = cbind(hours,migrations)
  
  #Make the dataframe for the migrations
  migrations_df = as.data.frame(migrations)
  names(migrations_df) = c("hours", mysisNames)
  migrations_plot = melt(migrations_df, id = 'hours')
  
  #Render the plot for the migrations
  # a = ggplot(migrations_plot, aes(x = hours, y = -value, group = variable)) + geom_line(aes(color = variable)) + 
  #   labs(title = "Mysis migration patterns for first 100 days of year", y = "Depth below surface", x = "") + theme(legend.position="none")
  
  #Assemble the dataframe for condition
  conditions_df = as.data.frame(cbind(hours, conditions))
  names(conditions_df) = c("hours", mysisNames)
  conditions_plot = melt(conditions_df, id = 'hours')
  
  #Find portion who died
  mysidsWhoDied = tail(conditions_df, 1)[1:numOfMysids+1] <= 0
  mortalityRate = sum(mysidsWhoDied)/numOfMysids
  
  subtitleText = paste(numOfMysids, "mysids, Reward:", rewardUnits, "Migration Cost:", migrationCost, ", Mortality Rate:",mortalityRate)
  
  #Draw condition plot
  b = ggplot(conditions_plot, aes(x = hours, y = value, group= variable)) + stat_smooth(aes(color = variable),method = "gam", formula = y ~ s(x, bs = "cs")) + 
  labs(title = "blah!", y = "energy units") + theme(legend.position="none") +  ggtitle(bquote(atop(.("Mysis Condition Over Year"), atop(italic(.(subtitleText)), "")))) 
  
  b
  ggsave(file = paste("figures/condition", rewardUnits, "_", migrationCost,".pdf", sep = ""))
  # #Plot both migrations and condition on top of eachother. 
  # Plot = arrangeGrob(a,b,ncol=1, main = paste("Migration and Condition,", "Mortality Rate:", mortalityRate) )
  # Plot 
  
  
  ############################################################################################################
  howManyMigrations = function(mysid){return(365 - sum(mysid[seq(19,(365*24), 24)] == 100))}
  ############################################################################################################
  
  mysidsWhoLived = mysidsWhoDied == FALSE
  
  daysMigrated = NULL
  
  for(indv in mysisNames[mysidsWhoLived]){ 
  daysSurvived = howManyMigrations(migrations_df[[indv]])
  daysMigrated = c(daysMigrated, daysSurvived)
  }
  
  survivingMysis = data.frame(daysMigrated)
  
  ggplot(survivingMysis, aes(x = daysMigrated)) + 
  geom_histogram(aes(y=..count../sum(..count..)), color = "black", fill = "#7fc97f", binwidth = 5) + 
  labs(title = "Days Migrated for Surviving Mysids", x = "Days Migrated", y = "Freq") 
  
  ggsave(paste("figures/days_migrated", rewardUnits, "_", migrationCost,".pdf", sep = ""))
}
