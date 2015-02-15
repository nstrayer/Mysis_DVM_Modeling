setwd("/Users/Nick/mysisModeling")

#Data comes from http://rredc.nrel.gov/solar/old_data/nsrdb/1991-2010/
solarRaw = read.csv("data/solarData2010.csv")

realSolar = solarRaw$METSTAT.Dif..Wh.m.2.
realSolarSmoothed = smooth.spline(realSolar)

plot(realSolarSmoothed, type = "l")
plot(realSolar, type = "l")

#Mid day
lightAtNoon = realSolar[seq(12, length(realSolar), 24)]
plot(lightAtNoon, type = "l", main = "Burlington Light Levels at Mid-Day for 2010", xlab = "Day of Year", ylab = "Light Levels in Wh/m^2")
lines(smooth.spline(lightAtNoon), col = "blue", lw = 4)
axis(side = 1)
axis(side = 1, col = "white", tcl = 0)
axis(side = 2)
axis(side = 2, col = "white", tcl = 0)
png("realSolar_noon_2010.png")


# #1 am
# nightLight = realSolar[1000:1048]
# plot(nightLight, type = "l", 
#      main = "Burlington Light Levels Jan 1 - Jan 2", 
#      xlab = "Hour", 
#      ylab = "Light Levels in Wh/m^2")
# axis(side = 1)
# axis(side = 1, col = "white", tcl = 0)
# axis(side = 2)
# axis(side = 2, col = "white", tcl = 0)


#Begin moonlight simulation to add to the real data: 
#Days vector for a year
hours = 1:(365*24)
cycle = 27*24 #27 days at 24 hours. 

#Nightime light level in lux
moonLux = NULL

for (hour in hours){
  cyclePoint = hour %% cycle
  moonLux = c(moonLux, 0.5 * cos((1/cycle)* 2*pi * cyclePoint ) + .5)
}

#Check to see if this is functional
plot(hours, moonLux, type = "l",
     main = "Light Levels at Midnight (Moon Cycle)",
     xlab = "hour",
     ylab = "Light Level in Lumens")
axis(side = 1)
axis(side = 1, col = "white", tcl = 0)
axis(side = 2)
axis(side = 2, col = "white", tcl = 0)


#This comes from the solar irradiance paper. Very iffy. 
Wh_to_lumen = 85.0;
combinedLight = NULL;
solarLux = NULL;

for (i in 1:(365*24)){
  solarLux = realSolar[i] * Wh_to_lumen;
  print(solarLux > moonLux[i])
  if (solarLux > moonLux[i]){
    combinedLight = c(combinedLight, solarLux)
  } else {
    combinedLight = c(combinedLight, moonLux[i])
  }
}

# Let's just check to make sure it's all good. 
#plot(combinedLight[1004:1005], type = "l")
summary(combinedLight)
#Yup! Okay, let's output it. 

write.csv(combinedLight, "data/light_day_moon_hour.csv_hour.csv", row.names=FALSE)
