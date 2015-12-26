library(shiny)

shinyUI(fluidPage(
  # Application title
  titlePanel("Central Limit Theorem demonstration"),
  
  # Sidebar with a slider input for the number of bins
  fluidRow(
    column(3,
      sliderInput("lambda", "Lambda:",
                       min = 0.1, max = 5, value = 0.2, step = 0.1),
      sliderInput("n", "Sample size (num averages):",
                  min = 1, max = 50, value = 40),           
      sliderInput("num_sim", "Number of simulations:",  
                  min = 20, max = 5000, value = 20, step = 20),
      submitButton("Submit")
    ),
    column(6, offset = 1,
           h4("Submitted values"),
           verbatimTextOutput("input_values"),
           br(),
           h4("Distributions parameters"),
           verbatimTextOutput("dist_values")           
    )
  ),
    
  hr(),
  plotOutput("doPlots")
))