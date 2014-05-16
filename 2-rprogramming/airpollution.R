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


complete <- function(directory, id = 1:332) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used
        
        ## Return a data frame of the form:
        ## id nobs
        ## 1  117
        ## 2  1041
        ## ...
        ## where 'id' is the monitor ID number and 'nobs' is the
        ## number of complete cases

        pathToDir <- paste(directory, "/", sep="")
        
        ## create the data.frame to hold the results
        numObs <- NULL # initialize a var to hold the df
        # names(numObs) <- c("id", "nobs") # set the column names
        # numObs <- numObs[-1,] # remove the dummy row


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

                numCompleteRows <- nrow(na.omit(data))
                tmp <- data.frame(i, numCompleteRows)
                numObs <- rbind(numObs, tmp)
        }
        
        names(numObs) <- c("id", "nobs")
        numObs
}


corr <- function(directory, threshold = 0) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'threshold' is a numeric vector of length 1 indicating the
        ## number of completely observed observations (on all
        ## variables) required to compute the correlation between
        ## nitrate and sulfate; the default is 0

        ## Return a numeric vector of correlations

        allRows <- NULL #initialize

        ## get list of all files in dir
        #############################################
        fList <- list.files(directory, full.names=TRUE)

        ## for each file in the list
        #############################################
        for (file in fList) {

                data <- read.csv(file) # read the file
                excised <- na.omit(data) # excise the empty rows
                print(file)

                allRows <- rbind(allRows, excised)# append to 
        }

        #allRows
        numRows <- nrow(allRows)
        if( numRows < threshold){ # if not enough measurements
                corVec <- numeric() #assign a numeric vector of length 0
        }
        else {
                sulfate <- allRows[,2]
                nitrate <- allRows[,3]
                print(c("sulf", length(sulfate), "nit", length(nitrate)))
                corVec <- cor(sulfate, nitrate)
        }

        corVec #return the vector of correlations
}