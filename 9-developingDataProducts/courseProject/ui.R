# ui.r
# displays a lissajous curve
######################################################


library(shiny);

shinyUI(fluidPage(
	titlePanel(
		h1("Lissajous Curves")	   
   	),

	# Left Sidebar with controls
	sidebarLayout(
		sidebarPanel(
		
			HTML("<h4><font color='red'>Use the sliders to choose values for A and B to plot a Lissajous curve.</font></h4>"),
			
			sliderInput(inputId="slider1", label="A", min=0, max=12, value=3, step=1),	
			
			sliderInput(inputId="slider2", label="B", min=0, max=12, value=6, step=1),
			
			br(),
			br(),
			
			p("A and B represent the frequency of each oscillator."),
			p("To form closed curves, try values like {1,2}, {2,3}, and {4,5}."),
			p("Form open curves with values like {1,3}, {2,6}, and {3,7}."),
			p("Closed Lissajous curves describe the interference between notes in a musical scale.")
# 			
# 			actionButton("action", label = "Action")
		),
	
		# Main Panel with Display Tabs (still within `sidebarLayout()` )
		mainPanel(
			HTML("<p>A <a href=https://en.wikipedia.org/wiki/Lissajous_curve>Lissajous curve</a> describes the relationship between two oscillators vibrating simultaneously. Equations for a Lissajous curve can take the simplified form:</p>"),
			
			HTML("<pre><h3>X = sin(A*t)          Y = sin(B*t)</h3></pre>"),
			
			br(),
			
			textOutput("text1"), 
		      	plotOutput("plot")
		) 
	)
));
