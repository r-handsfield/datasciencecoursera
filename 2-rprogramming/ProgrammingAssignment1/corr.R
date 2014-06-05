## Copyright 2014
## Robert Handsfield

## IN : char directory - name of the dir containing the files to read
##      num  threshold - minimum number of measurements required for calculation
##
## OUT: num  allCors - list of the correlation calcs for each file
##
## Reads all files in a specified dir.  If a file has the minimum 
## number of measurements, calcs the normed covariance (correlation)
## between the pollutants nitrate and sulfate (via the cor() fcn).  
##
## Returns a list with 1 cor value for each file

corr <- function(directory, threshold = 0) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'threshold' is a numeric vector of length 1 indicating the
        ## number of completely observed observations (on all
        ## variables) required to compute the correlation between
        ## nitrate and sulfate; the default is 0

        ## Return a numeric vector of correlations

        allCors <- NULL #initialize

        ## get list of all files in dir
        #############################################
        fList <- list.files(directory, full.names=TRUE)

        ## for each file in the list
        #############################################
        for (file in fList) {

                data <- read.csv(file) # read the file
                excised <- na.omit(data) # excise the empty rows
                #print(file)

                numRows <- nrow(excised) # count the rows

                if( numRows <= threshold){ # if not enough measurements
                        polCor <- numeric() #assign a numeric vector of length 0
                }
                else {
                        sulfate <- excised[,2]
                        nitrate <- excised[,3]
                        #print(c("sulf", length(sulfate), "nit", length(nitrate)))
                        polCor <- cor(sulfate, nitrate)
                }

                allCors <- c(allCors, polCor)
        }

        allCors #return the list of correlations
}