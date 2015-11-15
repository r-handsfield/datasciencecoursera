# server.r
# calculates a lissajous curve

library(shiny)

shinyServer(
	function(input, output) {
		
		reactive({
			output$a <- input$slider1
		})
		
		reactive({
			output$b <- input$slider2
		})		
		
		
		output$text1 <- renderText({paste("You have selected this")})
		output$text2 <- renderText({paste(input$slider1, '- ', input$slider2)})
		
		output$plot <- renderPlot({
			#lissajous stuff goes herex
			plot(x=(seq(0,input$slider1, length.out=5)), y=(seq(0,input$slider2, length.out=5))^2, xlab='X', col='red', main='Lissajous')
		})
# 		
# # 		output$blank <- renderPrint({"Lorem ipso ballsac"})
		output$blank <- renderPrint({c("Lorem ipso ballsac", a, input$slider1, input$slider2)})
# 		
# # 		output$table <- renderTable({x=df})
# 		output$table <- renderTable({(1:6)})
# 		
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