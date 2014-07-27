#  Getting and Cleaning Data Course Project

# The purpose of this project is to demonstrate your ability to collect, work with, and 
# clean a data set. The goal is to prepare tidy data that can be used for later analysis. 
# You will be graded by your peers on a series of yes/no questions related to the project. 
# You will be required to submit: 1) a tidy data set as described below, 2) a link to a 
# Github repository with your script for performing the analysis, and 3) a code book that 
# describes the variables, the data, and any transformations or work that you performed to 
# clean up the data called CodeBook.md. You should also include a README.md in the repo with 
# your scripts. This repo explains how all of the scripts work and how they are connected.  

# One of the most exciting areas in all of data science right now is wearable computing - 
# see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to 
# develop the most advanced algorithms to attract new users. The data linked to from the 
# course website represent data collected from the accelerometers from the Samsung Galaxy S 
# smartphone. A full description is available at the site where the data was obtained: 

# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# Here are the data for the project: 

# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each 
# activity and each subject. 
# Good luck!


# if not loaded, install and load necessary packages
# pkgList <- c("plyr", "Hmisc", "reshape", "data.table", "httr")
# pkgsLoaded <- pkgList %in% (.packages())
# # print("working1")
# if(FALSE %in% pkgsLoaded) {
# 	install.packages(pkgList)
# 	lapply(pkgList, library, character.only=T)
# }
# rm(pkgList, pkgsLoaded)


# download data zip
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest="uciData.zip", method="curl")


# unzip into dir and docs
#unzip("uciData.zip") #creates dir <UCI HAR Dataset>

run_analysis <- function() {
	path <- "./UCI HAR Dataset/";
	dfActivityLabels <- read.table(paste(path,"activity_labels.txt", sep=""),col.names=c("activity","label"));
	dfVarNames <- read.table(paste(path,"features.txt", sep=""), col.names=c("row","varName"));
	path <- "./UCI HAR Dataset/test/";
	dfTestSubjects <- read.table(paste(path,"subject_test.txt", sep=""), col.names="subject");
	dfTestData <- read.table(paste(path,"X_test.txt", sep=""));
	dfTestActivity <- read.table(paste(path,"Y_test.txt", sep=""), col.names="activity");

	path <- "./UCI HAR Dataset/train/";
	dfTrainingSubjects <- read.table(paste(path,"subject_train.txt", sep=""), col.names="subject");
	dfTrainingData <- read.table(paste(path,"X_train.txt", sep=""));
	dfTrainingActivity <- read.table(paste(path,"Y_train.txt", sep=""),col.names="activity");

	rm(path)

	# rbind the training and test frames together
	dfData<-rbind(dfTrainingData,dfTestData);

	# add the experiment variable names to the col names of the data sets
	colnames(dfData)<-dfVarNames$varName;

	# identify the mean & std measurements to extract
	meanStdCols<-grep("^.+-(mean|std)", names(dfData));

	# extract the mean & std measurements by subsetting
	dfData<-dfData[,meanStdCols];  ## verify by count(grepl("^.+-(mean|std)", names(dfData)));

	# remove the frequency domain "meanFreq" measurements
	meanFreqCols<-grep("-meanFreq()",names(dfData));
	dfData<-dfData[,-meanFreqCols];

	# create df factors to label experiment phases (test/training)
	dfTestPhase<-data.frame("phase"=rep("test", nrow(dfTestData)),stringsAsFactors=TRUE);
	dfTrainingPhase<-data.frame("phase"=rep("training", nrow(dfTrainingData)),stringsAsFactors=TRUE);

	# rbind the training and test phases, subjects, and activities
	dfPhase<-rbind(dfTrainingPhase,dfTestPhase);
	dfSubjects<-rbind(dfTrainingSubjects,dfTestSubjects);
	dfActivity<-rbind(dfTrainingActivity,dfTestActivity);

	# cbind the phase, subject, activity, and data
	dfMotion<-cbind( dfPhase, dfSubjects, dfActivity, dfData );

	# create a factor vector with the activity labels
	activityLabels<-factor(dfMotion$activity, levels=dfActivityLabels$activity, labels=dfActivityLabels$label);

	# replace the activity codes with names of the activities
	dfMotion$activity<-activityLabels;

	# calculate avg of all numeric measurements for each activity for each subject
	dfMotionAvg<-aggregate(dfMotion[4:69], by=list(subject=dfMotion$subject,activity=dfMotion$activity),mean);

	# remove helper variables
	rm(list=c("dfTestPhase","dfTrainingPhase","dfPhase","dfSubjects","dfTrainingActivity",
			"meanFreqCols","meanStdCols","activityLabels"));

	# write dfMotionAvg to a tidy data file
	write.table(dfMotionAvg, file="tidy_set.txt", sep = ",", row.names=FALSE, col.names = TRUE);

	dfMotionAvg
}
