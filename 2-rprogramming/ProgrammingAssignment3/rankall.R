## function best(state, outcome)
## Returns the hospital in the given US state with the given rank for the 
## 30-day death rate of a given illness.
##
## Reads a CSV of hospital outcomes from <http://hospitalcompare.hhs.gov>
##
## IN :	char state - the capitalized postal code for a US state/territory ex WV
##	char outcome - one of 3 medical conditions "heart attack", "heart failure", "pneumonia"
##	char/num num - the desired rank of a hospital, takes an integer, "best", "worst"
##
## OUT: char hospital - an alphebetized list of all hospitals with the desired rank
##
## Data Frame Columns:
## column 2 = hospital name
## column 7 = the US state
## column 11 = heart attack death rate
## column 17 = heart failure death rate
## column 23 = pneumonia death rate
##################################################################################

rankall <- function(outcome, num=best) {
	
	## Read outcome data
	data <- read.csv("ProgAssignment3-data/outcome-of-care-measures.csv", colClasses="character")
	
	## Check that outcome is valid
	validOutcomes <- c("heart attack", "heart failure", "pneumonia")
	
	if ( !(outcome %in% validOutcomes) ) {
		## if input outcome is not in the valid list
		## kill the program
		stop("invalid outcome")
	}
	
	## determine the column of interest based on the input outcome
	switch (outcome,
		"heart attack" =  column <- 11,
		"heart failure" = column <- 17,
		"pneumonia" = column <- 23)
	#print(c("Column", column))

	## strip rows with "Not Available" entries
	data <- subset(data, data[,column] != "Not Available")
	
	## coerce death rates from chars to nums
	data[,column] <- as.numeric(data[,column])

	## select the 'hospital', 'state', and 'outcome' columns
	  # in this subset, hospital, state, outcome become columns 1, 2, 3
	data <- data[,c(2,7,column)]

	## split data into groups by state
	sdata <- split(data, data[,2])

	## order each group by the ascending death rate
	sdata <- lapply(sdata, function(sdata) sdata[order(sdata[,3]),])
	# function selects all rows, all cols, then orders rows by col 3 - 'outcome'



	## check that the input rank is less than num of included hospitals
	if (class(num) == "numeric" & num > nrow(data)) {
		## if rank is higher than number of hospitals, return 'NA'
		#print("high num")
		return(NA)		
	}
	
	
	
	
	
	
	
	## create a vector of unique death rates
	## lowest rate will be in ranks[1], next lowest will be in ranks[2], etc.
	#ranks <- unique(data[,column]) #this awesome solution doesn't meet the stupid requirements, use next line
	ranks <- data[,column]
	
	## get the death rate corresponding to the desired rank
	if ( num == "best") {
		deathRate <- ranks[1]
	}
	else if ( num == "worst") {
		deathRate <- tail(ranks, n=1)
	}
	else {
		deathRate <- ranks[num]
	}
	#print(c("Death Rate", deathRate))
	
	## get all hospitals that share the corresponding death rate
	hospital <- data$Hospital.Name[data[,column] == deathRate]
	
	## Return the alphabetized list of hospitals
	
	  ## If multiple hospitals are in the list, sort them alphabetically
	  ## This command does not affect cases that return only 1 hospital
	sort(hospital, decreasing=FALSE)
		
}