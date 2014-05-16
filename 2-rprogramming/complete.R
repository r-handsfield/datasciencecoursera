## Copyright 2014 
## Robert Handsfield
##
## IN : char directory - the dir holding the data files
##      num  id - the id nums of the files to read
##
## OUT: df   dfNumObs - Nx2 df of the id & num complete observations 
##              
## Reads specified csv files and returns an Nx2 data.frame of the file  
## (sensor) id and number of complete records (rows)

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
        dfNumObs <- NULL # initialize a var to hold the df
        # names(dfNumObs) <- c("id", "nobs") # set the column names
        # dfNumObs <- dfNumObs[-1,] # remove the dummy row


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
                dfTmp <- data.frame(i, numCompleteRows)
                dfNumObs <- rbind(dfNumObs, dfTmp)
        }
        
        names(dfNumObs) <- c("id", "nobs") # add column names to data frame
        dfNumObs
}