setwd("/Users/Nick/mysisModeling")

#Data comes from http://rredc.nrel.gov/solar/old_data/nsrdb/1991-2010/
solarRaw = read.csv("outsideData/solarData2010.csv")

realSolar = solarRaw$METSTAT.Dif..Wh.m.2.

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

Wh_to_lumen = 120.0; #From Jensen et all. 
combinedLight = NULL;
solarLux = NULL;

for (i in 1:(365*24)){
  solarLux = realSolar[i] * Wh_to_lumen;
  if (solarLux > moonLux[i]){
    combinedLight = c(combinedLight, solarLux)
  } else {
    combinedLight = c(combinedLight, moonLux[i])
  }
}

write.csv(combinedLight, "data/light_day_moon_hour.csv", row.names=FALSE)
