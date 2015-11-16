# server.r for shiny tutorial lesson 5
# http://shiny.rstudio.com/tutorial/lesson5/
# 
# Data Download:
# http://shiny.rstudio.com/tutorial/lesson5/census-app/data/counties.rds	
# #########################################################################

# for downloading source data
# url <- "http://shiny.rstudio.com/tutorial/lesson5/census-app/data/counties.rds"
# download.file(url, method="wget", destfile = "counties.rds")
# counties <- readRDS("counties.rds")
# View(counties)

# install.packages( c('mapplots','mapStats','maptools') )
# library(c('mapplots','mapStats','maptools'))

library("maps"); library("mapproj"); library("shiny");
source("./helpers.R")

counties <- readRDS("./data/counties.rds")


shinyServer(function(input, output){

	output$map <- renderPlot({

		data <- switch(input$var, 
			       "Percent White" = counties$white,
			       "Percent Black" = counties$black,
			       "Percent Hispanic" = counties$hispanic,
			       "Percent Asian" = counties$asian
			       )
		
		# run the map generator from the 'helpers.r' file
		percent_map(var=data, color='blue', legend.title=input$var, min=input$range[1], max=input$range[2])
	})
	
	output$text1 <- renderText({input$range})
})
