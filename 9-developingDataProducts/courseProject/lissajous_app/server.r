# server.r
# calculates a lissajous curve
######################################################

library(shiny)

t <- seq(0, 2*pi, .01)

shinyServer(
	function(input, output) {
		
		# use value via A(), B(), etc.
		A <- reactive({ input$slider1 })
		
		B <- reactive({ input$slider2 })		
		
		# show slider values
		output$text1 <- renderText({paste0("You have selected A=", A(), " and B=", B() )})
		
		# plot the lissajous curve
		output$plot <- renderPlot({
			#lissajous stuff goes herex
			plot(
				x=sin(t*A()), 
				y=sin(t*B()), 
				xlab=paste('X = sin(', A(), ' * t )'),
				ylab=paste('Y = sin(', B(), ' * t )'),
				col='red', type='l', lwd=3, 
				main='Lissajous Curve  (Y vs X)'
			)
		})

	}
)
