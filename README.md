# Mysis DVM Model.

This repo contains the current code and notes on my senior thesis project at the University of Vermont.

# R Markdown Scripts: 

These are markdown style scripts detailing the workings of the components of the model. All are hosted on [RPubs](http://rpubs.com). 


- [Solar Data Cleaning](http://rpubs.com/nstrayer/64339)

- [Thermocline Model](http://rpubs.com/nstrayer/thermoclineModel)

- [Mysocline Depth Model](http://rpubs.com/nstrayer/64310)

# General scratchwork for the model: 

Potentially look at female reproductive stage. 

Figure out light an temp thresholds through whole year. 

Just get the model to be where the mysis gets to based upon lowest light or temp profile. 

Mysis start migrating at sundown and go back at sunrise. 


## distributions of food potential vary seasonally. 
e.g.
- mean is higher in summer
- spring has higher deviation




# Units of Light intensity!
It is of note that a lot of manipulation is being done for the units of light. The mysis threshold is given in lux, but lux is totally dependent upon a given wavelength of light[1]. I am using a __120 lux to w/m2__ ratio as that is what is quoted in Jensen Et. Al. 2006. Also, the raw solar data is in watt hours not just watts. However, since the increments are on an hourly timescale it appears to be the average over that hour and thus a 1:1 conversion to watts. Lots… of… assumptions… 


[1] Paper on the luminous efficiency of daylight: 
http://lrt.sagepub.com/content/17/4/162.short


# Depth component: 

If the mysis is alive and migrating then reach into the mysocline 

# File Structure: 

__depthModel(_md)__ : Takes in data from `solarData.r` and spits out the file `mysocline_hour.csv` that contains the expected migration extent at any given hour of the year. 

__solarData.r__ : Reads in raw solar data and combines with modeled lunar cycle to create light intensity estimates for any given hour of the year. 

