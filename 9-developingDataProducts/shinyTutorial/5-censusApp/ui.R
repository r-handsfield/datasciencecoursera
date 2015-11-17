# ui.r.r for shiny tutorial lesson 5
# http://shiny.rstudio.com/tutorial/lesson5/
# 
# Data Download:
# http://shiny.rstudio.com/tutorial/lesson5/census-app/data/counties.rds	
# #########################################################################

shinyUI(fluidPage(

	titlePanel("censusVis"),
	
	sidebarLayout(
		sidebarPanel(
			helpText("Create demographic maps with information from the 2010 US Census."),
		
			selectInput(
				inputId = "var",
				label = "Choose a variable to display",
				choices = c("Percent White", "Percent Black", "Percent Hispanic", "Percent Asian"),
				selected = "Percent White"
			),
			
			sliderInput(
				inputId = "range",
				label = "Range of interest:",
				min=0, max=100, value=c(0,100)			    
		    	)		
		),
	
		mainPanel(
			plotOutput(outputId = "map"),
			br(),
			textOutput(outputId = "text1")
		)
	)
))