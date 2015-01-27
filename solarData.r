setwd("/Users/Nick/mysisModeling")

#Data comes from http://rredc.nrel.gov/solar/old_data/nsrdb/1991-2010/
solarRaw = read.csv("data/726170_1991_solar.csv")

plot(solarRaw$METSTAT.Dif..Wh.m.2., type = "l")