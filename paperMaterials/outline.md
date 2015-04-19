# Modeling the DVM of Mysis
---


## Abstract:

## Introduction:
- Research into specific aspects of mysis dvm has been done before, none looking at it from such a pulled back view. 

Mysis _diluviana_ (Mysis) is a small macroinvertebrate crustacean that lives in deep glacial lakes. They occupy a critical niche in the food-web as during their diel vertical migration (or DVM) they transfer nutrients from the benthic to the pelagic environments of a lake. Previous research efforts into Mysis have been focused on particular aspects of their migrations (CITATIONS). In this paper we take a step back and access the sensitivity of migration to changes in different environmental parameters using monte-carlo style simulation of many individuals at an hourly timestep over a typical year. 

- Sampling is expensive, time consuming and inconvenient..

More traditional methods of measuring the effects of environmental changes are costly and time consuming, requiring many hours of sampling and with the inherent noise of real world sampling. 

- ...Modeling is not. 

By modeling we are able to investigate effects at a much lower cost and also escape the afformentioned pitfalls of real sampling to get a clear picture of the trends of effects. 


- Modeling is not perfect, but captures the underlying patterns well enough to drive further research into those specific aspects of DVM. 

It should be noted that the results and their specific units and/or amounts may not be exact, but what is important are the trends. We hope that the results from this modeling based exploration into DVM will help point future real-world sampling efforts in a more efficient and impactful direction. 

---

## Methods:

#### Programing Language: 

The programming language used for the model is R (CITATION). R was chosen due to its high adoption in the ecology community. This will allow for easier expansion of the model in the future. 

#### Agent Based: 

An agent based approach was used for the model as it allows the interogation of  effects at a small scale of environmental changes and allows for the potential detection of multiple stable-states in migration patterns through the use of monte-carlo style running of many agents over the same environmental conditions. 

#### Expandability: 

The environmental variables fed into the agent-based main model are generated using their own sub-models. This form was chosen because it allows the quick perturbation of environmental factors but also for it's ability for model data to be substituted with real data. As more sampling data is obtained it can be gradually integrated into the model to allow for more precise predictions and measurements of effects. 

### Variables: 


|  Variable | Value  | Description | Units | 
|---        |---     |---          |---    |
|$s$        | 1 for winter/spring, -1 for summer/fall     |Seasonality         
|$M$        | 40     |  Max Depth         |  Meters     |
|$C$        | .003   |  Curve Steepness     |       
|$m$        | 1667   |  Midpoint of curve     |  Hours     |
|$h$        | 1,2,...,8750      |    Hour of year      |   Hours    |
|$min$      | 0.15 | Minimum value of food availability ratio|       
|$max$      | 0.15 | Maximum value of food availability ratio| 
|$s$ | $\frac{min - max}{2}$ | 
|$a$ | $\frac{min + max}{2}$|
|$t$ | $\frac{1}{365 \cdot 24}$ | Sinusoidal scaler |
|$H$ | 5040 | Hour of peak availability| Hours|
|$c$ | $27.8 \cdot 24$ | Moon cycle length | Hours|
|$h_c$| $h$ modulous $c$ | The point in the moon cycle | Hours|
|$k$ | 0.3 | Extinction coefficient of lake (CITATION) | UNITS|
|$I_x$ | $1 \times 10 ^{-3}$ |Mysis Light threshold (CITATION) | Lux |
|$S_l$ | (input) | Light level at lake surface | Lux |


### Data Generating Models: 

Four sub-models were developed to generate environmental variables for the main model. R Markdown scripts of all data generate are availabile in the apendix at rpubs.com/nstrayer.


__Thermocline Model:__

The first is a model of the depth in the water column at which 10 degrees celicius is attained. This temperature was chosen as a Mysis threshold based upon the work of (CITATION). To model this two sigmoidal curves were joined together to form the pattern observed in all large bodies of water over a year. 

$$f(h) = \frac{s \cdot M}{1 + e^{-C(h - m)}}$$


<div style="text-align:center"><img src="figures/thermoclineModel.png" alt="termocline model" height="350"></div>

---

__Food Availability:__

The food availability ratio is bounded between 0 and 1 and is a normalized measure of food quality in the pelagic waters to the whole water column. E.g. food availability = 0.8 implies 80% of the food is available in the pelagic waters. 

$$f(h) = s \cdot \cos{[ (1/8750) \cdot 2\pi \cdot (h - H) + a]}$$


<div style="text-align:center"><img src="figures/foodAvailabilityModel.png" alt="termocline model" height="350"></div>


__Food Variablity:__

To generate the food variability curve for food availability we simply doubled the frequences of the same cosine curve to capture high variability in food availability during spring and fall. This value is used in the model to control the deviation of the distribution of the individual's feeding reward.


<div style="text-align:center"><img src="figures/foodVariabilityModel.png" alt="termocline model" height="350"></div>


---

### Isocline Depth:

Mysis are photophobic. (CITATION et al) looked at this sensitivity and found a threshold of light in lux (mention at what wavelength). The depth at which this  light level is reached the water column was modeled over the course of the entire year. To do this data of light intensity levels in Burlington were obtained from the National Renewable Energy Laboratory (NREL CITATION). Due to the sensitivity of the sensors in low light levels the data needed to be filled in with a simple moon cycle model. 

__Moon Cycle:__

Raw data was read in from the National Renewable Energy Laboratories data explorer (Citation), however the sensitivity was not high enough to pick up the lunar cycles. Due to this nighttime light intensity levels were substituted with the model. The greatest light intensity between the moon cycle model and real data was chosen for the final dataset. 

$$f(h_c) = 0.5\Big[\cos{\Big( \frac{1}{c}\cdot 2\pi \cdot h_c\Big)}\Big] + 0.5$$

---
__Beer's Law:__

Once a complete dataset was had for the year the light intensity was run through an equation derived from Beer's Law (CITATION). This equation takes in light intensity levels and returns the depth at which the mysis light threshold is reached. 


$$f(S_l) = \frac{1}{k} \cdot \log{\Big(\frac{S_l}{I_x}\Big)}$$

$k = $ Extinction coefficient, 

$I_x = $ Mysis Light threshold (Mysis light modeling citation),

$S_l = $ Surface light


<div style="text-align:center"><img src="figures/depthModel.png" alt="termocline model" height="350"></div>

---

### Probability to Migrate:

In order to simulate responses to body condition we generated a curve to influence a mysis' desire to migrate to their body condition. With this curve a mysis with a high body condition is less likely to migrate than a mysis with a low body condition with the midpoint of the sigmoid sitting at what we decided was a 'normal' mysis body condition.  

$$f(x) = \frac{1}{1 + e^{-k(x - m)}}$$

$k =$ Steepness of curve,

$m =$ Midpoint of curve,

<div style="text-align:center"><img src="figures/decisionCurve.png" alt="termocline model" height="350"></div>

---

### Agent Based Model: 

Our agent based model runs an individual through a year on an hourly time step. At every hour the mysis attempts to feed based upon its current habitat (Benthic or Pelagic). Twice a day, once one hour after sunset and then again one hour before sunrise the mysis decides to migrate based upon its condition and environmental food availability. 

__Main Model:__

<div style="text-align:center"><img src="figures/Agent_Based_Model.png" alt="termocline model" height="450"></div>

__Hourly Decision:__

<div style="text-align:center"><img src="figures/hourlyDecision.png" alt="termocline model" height="400"></div>


__Twice Daily Decision:__

<div style="text-align:center"><img src="figures/dailyDecision.png" alt="termocline model" height="400"></div>


---

__... This is the point I have made it to thus far.__ 

$k = $ Extinction coefficient, 

$I_x = $ Mysis Light threshold (Mysis light modeling citation),

$S_l = $ Surface light



- Made into shiny app to allow for interactivity 

## Results:

- Small perturbations in conditions such as ___ resulted in chaotic behavior. 

## Conclusions:

- The sensitive dependence upon initial conditions implies high sensitivity to environmental changes. 
