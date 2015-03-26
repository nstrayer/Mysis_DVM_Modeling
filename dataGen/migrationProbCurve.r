#Script to generate light levels for mysis dvm model. 
migrationProbability = function(condition){ #I am choosing to leave the random roll outside of script for continuity, could be changed
  mid = 150 #value of curve midpoint
  k = 0.03 #steepness of curve
  x = condition 
  
  dist = 1/(1 + exp(-k* (x - mid)))   
  return(dist)
}

# hours  = 0:(300) 
# dist = NULL
# 
# for (t in hours){ dist = c(dist, migrationProbability(t)) }
# 
# plot(dist)
# 
# data = cbind(hours, dist) # Wrap the data. 

