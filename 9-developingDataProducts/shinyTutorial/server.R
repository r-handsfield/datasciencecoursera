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

# install.packages( c('maps','mapproj','shiny') )
# pkgs <- c('maps','mapproj','shiny')
# l <- library()$results[,'Package']
# for(pk in pkgs) { if (!pk %in% l) { library(pk[1]) }}

library("maps"); library("mapproj"); library("shiny");

source("./helpers.R")
counties <- readRDS("./data/counties.rds")
percent_map(counties$white, "darkgreen", "% white")







