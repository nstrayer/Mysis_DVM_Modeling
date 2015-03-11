setwd("/Users/Nick/mysisModeling")
# Code for a simple food availability model based upon the assumptions of higher pelagic food quality
# in the summer. 

#First we set up some user defined variables. 
min     = 0.1 #minimum food availability value
max     = 0.9 #max 
highDay = 226 #Number of days into the year that the max food availability is (226 is aug 15)
august  = 5856 #hours into the year

#Now we generate the others
scaler    = (max - min)/2 #range divided by two
heightAdj = (max + min)/2 #average value
days      = 1:365 #Set up a day vector to loop over
#A variable that ranges from 0 (totally benthic) to 1 (totally pelagic) indicating food availability.
foodAvail = NULL  

#Quick loop to generate the data. 
for (day in days){
  foodAvail = c(foodAvail, scaler * cos( (1/365)*2*pi * (day - highDay)) + heightAdj)
}

plot(days,foodAvail, type = "l")

write.csv(foodAvail, "data/FoodAvail_Day.csv", row.names=FALSE)
