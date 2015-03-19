setwd("/Users/Nick/mysisModeling")

#First we set up some user defined variables. 
min     = 0.1 #minimum food availability value
max     = 0.9 #max 
highDay = 226*24 #Number of days into the year that the max food availability is (226 is aug 15)
august  = 5856 #hours into the year

##########################################################################################

#Now we generate the others
scaler    = (max - min)/2 #range divided by two
heightAdj = (max + min)/2 #average value
hours      = 1:(365*24) #Set up a hour vector to loop over
foodAvail = NULL  

#Quick loop to generate the data. 
for (hour in hours){
  foodAvail = c(foodAvail, scaler * cos( (1/(365*24))*2*pi * (hour - highDay)) + heightAdj)
}

##########################################################################################

min     = 0.01 #minimum food availability value
max     = 0.12 #max 
highDay = 100*24
scaler    = (max - min)/2 #range divided by two
heightAdj = (max + min)/2 #average value
variability = NULL

#Quick loop to generate the data. 
for (hour in hours){
  variability = c(variability, scaler * cos( (1/(365*24))*4*pi * (hour - highDay)) + heightAdj)
}

##########################################################################################

highBound = NULL
lowBound  = NULL

for (hour in hours){
  highBound = c(highBound, (foodAvail[hour] + variability[hour]))  
  lowBound = c(lowBound, (foodAvail[hour] - variability[hour]))
}

#distributionDf = as.data.frame(cbind(hours, highBound, lowBound))

##########################################################################################

#write.csv(distributionDf, "data/FoodAvail_Hour.csv", row.names=FALSE) #The bounded model  
write.csv(variability, "data/FoodAvail_Hour.csv", row.names=FALSE) #The plain side curve. 


