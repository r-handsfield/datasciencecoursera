pollutantmean <- function(directory, pollutant, id = 1:332) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files
        
        ## 'pollutant' is a character vector of length 1 indicating
        ## the name of the pollutant for which we will calculate the
        ## mean; either "sulfate" or "nitrate".

        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used

        ## Return the mean of the pollutant across all monitors list
        ## in the 'id' vector (ignoring NA values)

        
        pollutantList <- c() # initialize the list of pollutant values
        pathToDir <- paste(directory, "/", sep="")

        ## for every sensor in the argument 'id'
        for (i in id) {
        	## create the string pathToFile
        	## files named 004.csv, 012.csv, 315.csv, etc
        	#############################################
        	if(i < 10) {
        		## add 2 zeroes to files 1-9
        		fileName <- paste("00", i, ".csv", sep="")
        	}
        	else if(i>9 & i<100) {
        		## add 1 zero to files 10-99
        		fileName <- paste("0", i, ".csv", sep="")
        	}
        	else {
        		## don't add any zeroes to files 100+
        		fileName <- paste(i, ".csv", sep="")
        	}

        	## combine the dir path and file name
        	pathToFile <- paste(pathToDir, fileName, sep="")
        	#print(pathToFile)

        	## open the file
        	#############################################
        	data = read.csv(pathToFile)

        	## select a column based on pollutant type
        	## csv cols are Date, Sulfate, Nitrate, ID
        	#############################################
        	if (pollutant == "nitrate") {
        		col <- 3
        	}
        	else if (pollutant == "sulfate") {
        		col <- 2
        	}

        	## remove rows that have NA values in the
        	## selected column: sulfate|nitrate ~ 2|3
        	#############################################
        	mask <- !is.na(data[,col]) #marks NA rows as FALSE
        	validSet <- data[ mask, ]
        	#print(dim(data))
        	#print(dim(validSet))

        	## append data from this file to data from 
        	## all previous files
        	#############################################
        	pollutantList <- append(pollutantList, validSet[,col])
        	#print(length(validSet[,col]))
        	#print(length(pollutantList))
        }

        ## calculate mean of all the pollutant values
        ## (for selected pollutant)
        #############################################
        mean(pollutantList)
        
}

