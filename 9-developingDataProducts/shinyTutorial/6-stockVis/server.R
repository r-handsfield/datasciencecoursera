#####################################################
# Shiny Tutorial 6: stockVis app    
#
# http://shiny.rstudio.com/tutorial/lesson6/
#####################################################


# server.R

if (! 'quantmod' %in% installed.packages()[,'Package']){
	install.packages("quantmod")	
}

library(quantmod)
source("helpers.R")

shinyServer(function(input, output) {

  data <- reactive({
    getSymbols(input$symb, src = "yahoo",
    	from = input$dates[1], to = input$dates[2],
      	auto.assign = FALSE)
  })

  adjData <- reactive({
  		if (input$adjust) {
  			return( adjust(data()) )
  		}
  		data()
  })

  # use reactive function like a var, but by calling it in place: fcn_value = fcn()
  output$plot <- renderPlot({
    chartSeries(adjData(), theme = chartTheme("white"), 
      type = "line", log.scale = input$log, TA = NULL)
  })
  
})
