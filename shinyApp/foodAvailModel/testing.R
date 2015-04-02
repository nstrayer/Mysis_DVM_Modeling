
#First we set up some user defined variables. 
min     = 0.15 #minimum food availability value
max     = 0.97 #max 
highDay = 210*24 #Number of days into the year that the max food availability is (226 is aug 15)
august  = 5856 #hours into the year


#Now we generate the others
scaler    = (max - min)/2 #range divided by two
heightAdj = (max + min)/2 #average value
hours      = 1:(365*24) #Set up a hour vector to loop over
foodAvail = NULL  

#Quick loop to generate the data. 
for (hour in hours){
  foodAvail = c(foodAvail, scaler * cos( (1/(365*24))*2*pi * (hour - highDay)) + heightAdj)
}


#plot(hours,foodAvail, type = "l")

foodAvailDf = data.frame(hours, foodAvail)