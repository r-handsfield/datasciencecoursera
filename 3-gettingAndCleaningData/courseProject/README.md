###Coursera - Getting and Cleaning Data

##Course Project ReadMe

This project involves the processing of motion sensor data from a Samsung
smartphone.  30 subjects each performed several of 6 activities.  Each performance
was 1 trial, and each trial had many observations of 561 variables.  This data is
useful for creating wearable fitness devices and health algorithms.

The script contained in "run_analysis.R" automatically reads the appropriate raw
data, calculates the averages of specific measurements for each trial (listed by
subject and activity), and writes the results to txt and csv files.  

The user only needs to download the source archive, extract it into their working
directory, and run the "run_analysis" function.

#Follow the instructions
Install the packages "httr" and "plyr"

Download the source data from the following link
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Unzip the data, this will create the directory "UCI HAR Dataset"

Load the script "run_analysis.R" 

Run the function "run_analysis"


#The function performs the following actions:
*creates a path into the UCI HAR Dataset directory
*reads the data and descriptor files into R data frames
*rbinds the training and test data sets
*takes variable names from "features.txt" and adds them to the columns of the data set
*identifies and subsets all columns containing "mean" or "std" 
*identifies and removes all columns containing "meanFreq"
*rbinds test and training sets of subjects and activities
*cbinds sets together in a frame of: subject, activity, measurements
*creates a factor vector, binding activity labels to the numbered observed activities
*replaces the activity codes with activity labels

At this point the data is in a tidy frame with columns representing the subjects,
the activities, and the 66 means of the 561 raw measurements.  

Each row is 1 set of measurements of 1 subject during one of the 6 activites.

#The function then:
*calculates the mean of measurements, averaged by subject and activity
*writes the resulting data frame to txt and csv files ("tidy_data.txt")
