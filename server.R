library(shiny)
library(ggplot2)
library(dplyr)

# Simulates sims x games, with target score of risk
greedyResults <- function(risk, sims, beatPrevious) {
    scores <- numeric(sims)
    best <- 0
    for (n in 1:sims) {
        score <- 0
        repeat{
            # Simulate a dice roll
            roll <- sample(1:6,1) 
            if (roll == 6) { # Greedy, game over, score is zero
                score <- 0
                break
            } else {
                score <- score + roll # Accumulate score
            }
            # If not aiming to beat best so far, stop when score reaches target (risk)
            # Otherwise keep on going to try to beat best score so far
            if ((!beatPrevious & score >= risk) | (score >= risk & score > best)){
                break
            }
        }
        scores[n] <- score
        # Update best score    
        if (score > best) {best <- score}
    }
    scores
}

shinyServer(function(input, output) {
    rScores <- reactive({
        # Makes reactive expression dependent on action button to run simulation again
        input$run
        # Generate simulated game scores (global.R)
        gScores <- greedyResults(input$risk, input$simulations, input$beatPrevious)
        # Form data.frame with scores
        gScoresDF <- data.frame(score = gScores)
        # Add end outcome
        gScoresDF$Outcome <- ifelse(gScoresDF$score == 0, "Greedy", "Winner")
        gScoresDF
    })    
    
    # Simulation Plot
    output$distPlot <- renderPlot({
        # Get scores (this part is reactive)
        greedyScores <- rScores()
        meanscore <- mean(greedyScores$score)
        ggplot(greedyScores, aes(x = factor(score), fill = Outcome)) +
            geom_bar() +
            scale_fill_manual(values=c("#BB2222", "#22BB22")) +
            labs(title = paste("Scores for", input$simulations, "simulated games"), x = "Score", y = "Count", subtitle = paste("Mean score = ", meanscore)) +
            theme(plot.title = element_text(size = 18, face = "bold"), plot.subtitle = element_text(size = 14))
    })
    
    output$scores <- renderText({
        rScores()$score
    })
    
    # Theory Plot
    output$concPlot <- renderPlot({
        # Isolated to ensure code is not run uneccesarily, as it does not change
        isolate({
          # Final simulation was done with 100,000 runs per risk. The results are cached to a file to reduce server load.
          riskMeans <- read.csv("riskMeans.csv")
            ggplot(riskMeans, aes(x = factor(risk), y = mean)) +
                geom_bar(stat = "identity", fill = "blue") +
                labs(title = "Mean score obtained vs Score aimed for", x = "Minimum score aimed for", y = "Mean score obtained") +
                theme(plot.title = element_text(size = 18, face = "bold"))
        })
    })
})
