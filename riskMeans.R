# As a very large number of simulations was used, the results were cached to a file
set.seed(123)
risk <- 1:25
# Run simulations 100,000 times each for each risk (minimum score aimed for)
riskScores <- sapply(risk, greedyResults, 100000, FALSE)
# Calculate mean obtained score and save to file 
riskMeans <- data.frame(risk = risk, mean = colMeans(riskScores))
write.csv(riskMeans,"riskMeans.csv")