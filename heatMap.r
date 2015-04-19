setwd("/Users/Nick/mysisModeling")
library(tidyr)
data = read.csv("data/results_0.64-0.69_18-21.5.csv")
data[,1] = NULL #Reading in the csv creates a junk column
names(data) = c("rewardUnits", "migrationCost", "mortality")
data <- data[order(data$rewardUnits),]
data_spread = spread(data, rewardUnits, mortality)
data_matrix = data.matrix(data_spread)
test        = data_matrix[, 2:dim(data_matrix)[2]] #May need to change. 
row.names(test) =  unique(data$migrationCost) 
heatmap(test, Rowv=NA, Colv=NA, xlab = "Reward Units", ylab = "Migration Cost",heat.colors(256))
