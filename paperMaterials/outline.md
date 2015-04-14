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


## Methods:

- Coded in R

The programming language used for the model is R (CITATION). R was chosen as it is the most accessable to members of the community that will benefit from the model. This will enhance the models future use by researchers. 

- Agent Based

An agent based approach was used in the construction of the model as it allows one to see the effects at a small scale of environmental changes and allows for the potential detection of multiple stable-states in migration patterns through the use of monte-carlo style running of many agents over the same environmental conditions. 

- Built on models, but with room for real data

The environmental variables fed into the agent-based main model are generated using their own sub-models. This form was chosen because it allows the quick perturbation of environmental factors but also for it's ability for model data to be substituted with real data. As more sampling data is obtained it can be gradually integrated into the model to allow for more precise predictions and measurements of effects. 

- Equations of the models

The sub-models that make up the utilized data are as follows: 

---

__Thermocline Model:__

$s =$ Seasonality (1 for winter/spring, -1 for summer/fall), 

$M =$ Max Depth,

$k =$ Steepness of curve,

$m =$ Midpoint of curve,

$h =$ Hour of year

$$f(h) = \frac{s \cdot M}{1 + e^{-k(h - m)}}$$

---

__Food Availability__

$min = $ Minimum value of food availability ratio,

$max = $ Maximum value of food availability ratio, 

$s = \frac{min - max}{2}$, 

$t = \frac{1}{365 \cdot 24}$, 

$H = $ Hour of peak availability, 

$a = \frac{min + max}{2}$ 


$$f(h) = s \cdot \cos{[t  \cdot 2\pi \cdot (h - H) + a]}$$

---

__Isocline Depth__

(Beer's Law citation)

$k = $ Extinction coefficient, 

$I_x = $ Mysis Light threshold (Mysis light modeling citation)

$S_l = $ Surface light

$$f(S_l) = 1/k \cdot \log{\Big(\frac{S_l}{I_x}\Big)}$$

---

__Moon Cycle__

Raw data was read in from the National Renewable Energy Laboratories data explorer (Citation), however the sensitivity was not high enough to pick up the lunar cycles. Due to this nighttime light intensity levels were substituted with the equation: 

$c = $ Moon cycle length, 

$h = h_c (\text{mod }c)$

$$f(h_c) = 0.5\Big[\cos{\Big( \frac{1}{c}\cdot 2\pi \cdot h_c\Big)}\Big] + 0.5$$

---

__... This is the point I have made it to thus far.__ 

---

- Made into shiny app to allow for interactivity 

## Results:

- Small perturbations in conditions such as ___ resulted in chaotic behavior. 

## Conclusions:

- The sensitive dependence upon initial conditions implies high sensitivity to environmental changes. 


# Model To-Do's

- Tie the reward value to the time of the year. 