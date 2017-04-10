library(shiny)

shinyUI(fluidPage(

  titlePanel("Greedy"),
  h3("Risk & Reward"),
  p("In the simple dice game called 'Greedy', you roll the dice as many times as you like, accumulatng your score.
    But if you get too greedy and don't stop before you roll a 6, you lose everything!"),
  p("In this simulation, you can set the strategy and number of games to simulate."),
  p("You can also simulate attempting to beat the best previous score. e.g. A group of friends trying to beat each other"),
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      sliderInput("risk",
                  "Risk - Stop when score reaches at least:",
                  min = 1,
                  max = 100,
                  value = 5),
      sliderInput("simulations",
                  "Number of simulated games",
                  min = 1,
                  max = 100,
                  value = 50),
      checkboxInput("beatPrevious", "Always roll to beat best previous score", value = FALSE),
      actionButton("run", "Run simulation again")
    ),

    # Show a plot of the distribution of scores or obtained vs minimum score aimed for
    mainPanel(
        tabsetPanel(type = "tabs", 
                    tabPanel("Simulation", br(), 
                             plotOutput("distPlot"),
                             h3("Scores"),
                             textOutput("scores")),    
                    tabPanel("Theory", br(), 
                             p("In theory the lowest score to aim for should be 15, as if this score is reached
                               the expected loss (from rolling a 6) is equal to the expected gain (from rolling 1 to 5)"),
                             p("Below this score, you can expect to gain from rolling again. Above it, you can expect to lose"),
                             p("below are the results from running 100,000 simulated games each for the minimum scores aimed for 1 to 25"),
                             plotOutput("concPlot")
                             )
        )
    )
  )
))
