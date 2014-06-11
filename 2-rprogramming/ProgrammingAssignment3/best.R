##
##

## column 2 = hospital name
## column 7 = the US state
## column 11 = heart attack death rate
## column 17 = heart failure death rate
## column 23 = pneumonia death rate
############

best <- function(state, outcome) {
	
	## Read outcome data
	data <- read.csv("ProgAssignment3-data/outcome-of-care-measures.csv", colClasses="character")
	
	## Check that state and outcome are valid
	validStates <- unique(data$State)
	validOutcomes <- c("heart attack", "heart failure", "pneumonia")
	
	if ( !(state %in% validStates) ) { 
		## if input state is not a US state
		## kill the program
		stop("invalid state")
	}
	else if ( !(outcome %in% validOutcomes) ) {
		## or if input outcome is not in the valid list
		## kill the program
		stop("invalid outcome")
	}
	
	## determine the column of interest based on the input outcome
	switch (outcome,
		"heart attack" =  column <- 11,
		"heart failure" = column <- 17,
		"pneumonia" = column <- 23)
	#print(column)
	
	## select hospitals located in the input US state
	data <- subset(data, data[,7] == state)
	
	## strip rows with "Not Available" entries
	data <- subset(data, data[,column] != "Not Available")
	
	## coerce death rates from chars to nums
	data[,column] <- as.numeric(data[,column])
	#tmp4 <<- data
	
	## get the lowest death rate in the state
	lowest <- min(as.numeric(data[,column]))
	
	## Return hospital in that state w/ lowest 30-day death rate
	
	hospital <- data$Hospital.Name[data[,column] == lowest]
	#print(lowest)	
	#print(length(hospital))
	
	## If multiple hospitals are in the list, sort them alphabetically
	## This command does not affect cases that return only 1 hospital
	sort(hospital, decreasing=FALSE) ## Return the alphabetized hospital names
		
}