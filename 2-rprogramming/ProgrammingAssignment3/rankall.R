## function rankall(outcome, num)
## Returns the hospital in the every US state with the given rank for the 
## 30-day death rate of a given illness.
##
## Reads a CSV of hospital outcomes from <http://hospitalcompare.hhs.gov>
##
## IN :	char outcome - one of 3 medical conditions "heart attack", "heart failure", "pneumonia"
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

rankall <- function(outcome, num='best') {
	
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

	## rename columns into readable form
	colnames(data) <- c("hospital", "state", "outcome")
	print(colnames(data))
	## split data into groups by state
	sdata <- split(data, data[,"state"])

	## order each group by the ascending death rate
	sdata <- lapply(sdata, function(sdata) sdata[order(sdata[,"outcome"]),])
	# function selects all rows, all cols, then orders rows by col 3 - 'outcome'
	#print(head(sdata),1)

	## if rank is 'best' or 'worst', return the hospitals from the ordered list
	if (num == "best") {
		sdata <- lapply(sdata, function(sdata) head(sdata, n=1L))	
	}
	else if (num == "worst") {
		sdata <- lapply(sdata, function(sdata) tail(sdata, n=1L))	
	}

	## if the desired rank is not "best" or "worst"
	  ## check that the input rank is less than num of included hospitals in the state
	if (class(num) == "numeric") {

		sdata <- lapply(sdata, function(sdata) sdata[num,])
	}

	sdata <- do.call(rbind.data.frame, sdata)[,1:2]
	sdata[,"state"] <- rownames(sdata)

	sdata
}