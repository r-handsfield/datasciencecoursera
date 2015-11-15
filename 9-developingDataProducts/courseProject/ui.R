# ui.r
# displays a lissajous curve

library(shiny);

shinyUI(fluidPage(
	titlePanel("Lissajous Curve"),
	
	# Left Sidebar with controls
	sidebarLayout(
		sidebarPanel(
			sliderInput(inputId="slider1", label="slider 1", min=0, max=1, value=.5, step=.01),	
			
			br(),
			
			sliderInput(inputId="slider2", label="slider 2", min=0, max=1, value=.5, step=.01),
			
			br(),
			
			actionButton("action", label = "Action")
		),
	
		# Main Panel with Display Tabs (still within `sidebarLayout()` )
		mainPanel(tabsetPanel(type="tabs",
				      tabPanel(title = "Text", textOutput("text1"), textOutput("text2")),
				      tabPanel(title = "Plot", plotOutput("plot")),
				      tabPanel(title = "Blank", verbatimTextOutput("blank")),
				      tabPanel(title = "Table", tableOutput("table"))
		))	
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
