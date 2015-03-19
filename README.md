# Mysis DVM Model.

This repo contains the current code and notes on my senior thesis project at the University of Vermont.

# R Markdown Scripts / Structure: 

These are markdown style scripts detailing the workings of the components of the model. All are hosted on [RPubs](http://rpubs.com). 

- [Main Model](http://rpubs.com/nstrayer/mainModel): This is the script that drives the whole process. It calls out to the following scripts in the `dataGen/` folder to generate data. 

	- [Solar Data Cleaning](http://rpubs.com/nstrayer/64339)

	- [Thermocline Model](http://rpubs.com/nstrayer/thermoclineModel)
	
	- [Mysocline Depth Model](http://rpubs.com/nstrayer/64310)

# Potential paths: 

* Potentially look at female reproductive stage. 


# To Do: 

* Distributions of food potential vary seasonally. 
	e.g.
	- mean is higher in summer
	- spring has higher deviation

* Change the desire to migrate higher if the mysis is already migrated. This will prevent them from bouncing up and down multiple times a night. 






# Units of Light intensity!
It is of note that a lot of manipulation is being done for the units of light. The mysis threshold is given in lux, but lux is totally dependent upon a given wavelength of light[1]. I am using a __120 lux to w/m2__ ratio as that is what is quoted in Jensen Et. Al. 2006. Also, the raw solar data is in watt hours not just watts. However, since the increments are on an hourly timescale it appears to be the average over that hour and thus a 1:1 conversion to watts. Lots… of… assumptions… 


[1] Paper on the luminous efficiency of daylight: 
http://lrt.sagepub.com/content/17/4/162.short

# Choice to migrate: 

## 2 options: 

1. Additive probability.
	- Could potentially force too many to migrate. 

2. Multiplicative probability. 
	- Has the potential to drive most mysids to not migrate. 

## Form:

1. Am I going or staying based food avail curve 
2. If going, draw number from logistic curve, decide based upon that number. 


