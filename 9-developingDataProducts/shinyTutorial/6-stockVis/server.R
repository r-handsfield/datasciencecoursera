#####################################################
# Shiny Tutorial 6: stockVis app    
#
# http://shiny.rstudio.com/tutorial/lesson6/
#####################################################


# server.R

library(quantmod)
source("helpers.R")

shinyServer(function(input, output) {

  output$plot <- renderPlot({
    data <- getSymbols(input$symb, src = "yahoo", 
      from = input$dates[1],
      to = input$dates[2],
      auto.assign = FALSE)
                 
    chartSeries(data, theme = chartTheme("white"), 
      type = "line", log.scale = input$log, TA = NULL)
  })
  
})
