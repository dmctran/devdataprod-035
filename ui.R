library(shiny)

shinyUI(navbarPage("Central Limit Theorem demonstration", fluid = TRUE,
  # application
  tabPanel("App", 
      fluidRow(
        column(3,
          # lambda for the exponentinal distribution
          sliderInput("lambda", "Lambda:",
                           min = 0.1, max = 5, value = 0.2, step = 0.1),
          # number of samples used in taking an average
          sliderInput("n", "Sample size (of an average):",
                      min = 1, max = 50, value = 40),
          # number of averages to be taken
          sliderInput("num_sim", "Number of simulations:",  
                      min = 20, max = 5000, value = 20, step = 5),
          
          submitButton("Submit")
        ),
        # echo input parameters and distributions parameters/values
        column(8, offset = 1,
               h4("Submitted values"),
               verbatimTextOutput("input_values"),
               br(),
               h4("Distributions parameters"),
               verbatimTextOutput("dist_values")           
        )
      ),
        
      hr(),
      plotOutput("doPlots")
  ),
  # help/documentation
  tabPanel("Documentation", includeMarkdown('documentation.Rmd'))
)
)