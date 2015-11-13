# server.r
# calculates a lissajous curve

library(shiny)

# shinyServer(
# 	function(input, output) {
# 		
# 		a <- input$slider1
# 		b <- input$slider2
# 		
# 		x <- c(1:6)
# 		Y <- x^2
# 		
# 		df <- data.frame(cbind(a,b))
# 		
# 		output$plot <- renderPlot({
# 			#lissajous stuff goes here
# 			plot(x=1:6, y=x*x, xlab='X', col='lightblue', main='Lissajous')
# 		})
# 		
# 		output$blank <- renderPrint({"Lorem ipso ballsac"})
# 		
# 		output$table <- renderTable({df})
# 		
# 	}
# )



shinyServer(function(input, output) {
	
	data <- reactive({
		dist <- switch(input$dist,
			       norm = rnorm,
			       unif = runif,
			       lnorm = rlnorm,
			       exp = rexp,
			       rnorm)
		
		dist(input$n)
	})
	
	output$plot <- renderPlot({
		dist <- input$dist
		n <- input$n
		
		hist(data(), 
		     main=paste('r', dist, '(', n, ')', sep=''))
	})
	
	# Generate a summary of the data
	output$summary <- renderPrint({
		summary(data())
	})
	
	# Generate an HTML table view of the data
	output$table <- renderTable({
		data.frame(x=data())
	})
	
})