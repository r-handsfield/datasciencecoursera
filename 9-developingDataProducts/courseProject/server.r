# server.r
# calculates a lissajous curve

library(shiny)

t <- seq(0, 2*pi, .01)

shinyServer(
	function(input, output) {
# 		
# 		reactive({
# 			output$a <- input$slider1
# 		})
# 		
# 		reactive({
# 			output$b <- input$slider2
# 		})		
		
		
		output$text1 <- renderText({paste("You have selected this")})
		output$text2 <- renderText({paste(input$slider1, '- ', input$slider2)})
		
		output$plot <- renderPlot({
			#lissajous stuff goes herex
			plot(x=sin(t*input$slider1), y=sin(t*input$slider2), xlab='X', col='red', type='l', main='Lissajous')
		})

		output$blank <- renderPrint({c("Lorem ipso ballsac", a, input$slider1, input$slider2)})

# 		output$table <- renderTable({(1:6)})
	}
)



# shinyServer(function(input, output) {
# 	
# 	data <- reactive({
# 		dist <- switch(input$dist,
# 			       norm = rnorm,
# 			       unif = runif,
# 			       lnorm = rlnorm,
# 			       exp = rexp,
# 			       rnorm)
# 		
# 		dist(input$n)
# 	})
# 	
# 	output$plot <- renderPlot({
# 		dist <- input$dist
# 		n <- input$n
# 		
# 		hist(data(), 
# 		     main=paste('r', dist, '(', n, ')', sep=''))
# 	})
# 	
# 	# Generate a summary of the data
# 	output$summary <- renderPrint({
# 		summary(data())
# 	})
# 	
# 	# Generate an HTML table view of the data
# 	output$table <- renderTable({
# 		data.frame(x=data())
# 	})
# 	
# })