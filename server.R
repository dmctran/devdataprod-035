library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  # display plots
  output$doPlots <- renderPlot({
    # parameters
    n <- input$n
    num_sim <- input$num_sim    
    lambda <- input$lambda

    # print params    
    input_values <- data.frame(c(lambda, n, num_sim), 
                               row.names = c("Lambda:", 
                                             "Sample size (of an average):",
                                             "Number of simulations:"))    
    colnames(input_values) <- ""
    output$input_values <- renderPrint({input_values})
    
    # exponential distribution
    exp_mean <- 1/lambda
    exp_stdev <- 1/lambda
    exp_var <- exp_stdev ^ 2
    exp <- c(mean = exp_mean, var = exp_var, sd = exp_stdev)
    
    # theoretical properties of distribution of samples (of averages)
    norm_mean <- exp_mean
    norm_var <- exp_var / n
    norm_stdev <- sqrt(norm_var)
    theorical <- c(norm_mean, norm_var, norm_stdev)
    
    # sampling
    set.seed(11)
    data1 = NULL
    for (i in 1 : num_sim) data1 = c(data1, mean(rexp(n, lambda)))
    
    sample_mean <- mean(data1)
    sample_var <- var(data1)
    sample_stdev <- sd(data1)
    sample <- c(sample_mean, sample_var, sample_stdev)
    
    # summary of values
    dist_values <- round(rbind("Exponential distribution" = exp, 
                               "Theoretical (distribution of averages)" = theorical, 
                               "Distribution of averages" = sample), 2)
    output$dist_values <- renderPrint({dist_values})
    
    # plot
    layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE),
           widths=c(1,1), heights=c(5,4))
    
    # mean of sample
    main_1 <- paste("Distribution of the mean of", n, "exponentials (")
    main_params <- list(n = n, lambda = lambda)
    hist(data1, breaks = 21, probability = TRUE, 
         main = bquote("Distribution of the mean of" ~ .(main_params$n) 
                       ~ "exponentials (" ~ lambda == .(main_params$lambda) ~ ")"),
         xlab = NULL)
    abline(v = norm_mean, lwd = 2, lty = 2, col = "blue")
    abline(v = sample_mean, lty = 2, col = "red")
    lines(norm_mean - norm_stdev, 0.02, col = "blue", type = "p", pch = 17)
    lines(norm_mean + norm_stdev, 0.02, col = "blue", type = "p", pch = 17)
    lines(sample_mean - sample_stdev, 0, col = "red", type = "p", pch = 16)
    lines(sample_mean + sample_stdev, 0, col = "red", type = "p", pch = 16)
    curve(dnorm(x, mean = norm_mean, sd = norm_stdev), 
          col = "blue", lwd = 2, add = TRUE)
    legend("topright", bty = "n", 
           legend = c("Normal distribution",
                      "Theoretical mean", "Sample mean", 
                      "1 theoretical stdev", "1 sample stdev"), 
           col = c("blue", "blue", "red", "blue", "red"), 
           lty = c(1, 2, 2, NA, NA),
           lwd = c(2, 2, 1, NA, NA),
           pch = c(NA, NA, NA, 17, 16))
    
    # exponential
    curve(dexp(x, rate = lambda), col = "darkblue", lwd = 2, from = 0, to = 30,
          main = bquote("Underlying Exponential distribution (" 
                        ~ lambda == .(main_params$lambda) ~ ")"),
          xlab = NULL, y = "Density")
    abline(v = exp_mean, lty = 2, col = "red")
    mean_label <- paste("Mean", round(sample_mean, 2))
    legend("right", bty = "n", legend = mean_label, col = "red", lty = 2)
    
    # qq
    qqnorm(data1)
    qqline(data1, col = "darkblue", lwd = 2)
  })
})