setwd("/Users/Nick/mysisModeling")

#Data comes from http://rredc.nrel.gov/solar/old_data/nsrdb/1991-2010/
solarRaw = read.csv("data/solarData2010.csv")

lightLevels = solarRaw$METSTAT.Dif..Wh.m.2.
lightLevelsSmoothed = smooth.spline(lightLevels)

plot(lightLevelsSmoothed, type = "l")
plot(lightLevels, type = "l")

#Mid day
lightAtNoon = lightLevels[seq(12, length(lightLevels), 24)]
plot(lightAtNoon, type = "l", main = "Burlington Light Levels at Mid-Day for 2010", xlab = "Day of Year", ylab = "Light Levels in Wh/m^2")
lines(smooth.spline(lightAtNoon), col = "blue", lw = 4)
axis(side = 1)
axis(side = 1, col = "white", tcl = 0)
axis(side = 2)
axis(side = 2, col = "white", tcl = 0)
png("LightLevels_noon_2010.png")


#1 am
nightLight = lightLevels[1000:1048]
plot(nightLight, type = "l", 
     main = "Burlington Light Levels Jan 1 - Jan 2", 
     xlab = "Hour", 
     ylab = "Light Levels in Wh/m^2")
axis(side = 1)
axis(side = 1, col = "white", tcl = 0)
axis(side = 2)
axis(side = 2, col = "white", tcl = 0)


