# ui.r
# displays a lissajous curve

library(shiny);

shinyUI(fluidPage(
	titlePanel("Lissajous Curve"),
	
	# Left Sidebar with controls
	sidebarLayout(
		sidebarPanel(
			sliderInput(inputId="slider1", label="slider 1", min=0, max=12, value=5, step=1),	
			
			br(),
			
			sliderInput(inputId="slider2", label="slider 2", min=0, max=12, value=4, step=1)#,
			
# 			br(),
# 			
# 			actionButton("action", label = "Action")
		),
	
		# Main Panel with Display Tabs (still within `sidebarLayout()` )
		mainPanel(
			textOutput("text1"), 
			textOutput("text2"),
		      	plotOutput("plot")
		) 
	)
));

# shinyUI(fluidPage(
# 	
# 	# Application title
# 	titlePanel("Tabsets"),
# 	
# 	sidebarLayout(
# 		sidebarPanel(
# 			radioButtons("dist", "Distribution type:",
# 				     c("Normal" = "norm",
# 				       "Uniform" = "unif",
# 				       "Log-normal" = "lnorm",
# 				       "Exponential" = "exp")),
# 			br(),
# 			
# 			sliderInput("n", 
# 				    "Number of observations:", 
# 				    value = 500,
# 				    min = 1, 
# 				    max = 1000)
# 		),
# 		
# 		# of the generated distribution
# 		mainPanel(
# 			tabsetPanel(type = "tabs", 
# 				    tabPanel("Plot", plotOutput("plot")), 
# 				    tabPanel("Summary", verbatimTextOutput("summary")), 
# 				    tabPanel("Table", tableOutput("table"))
# 			)
# 		)
# 	)
# ))
