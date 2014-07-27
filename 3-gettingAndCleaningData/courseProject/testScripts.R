# for course project

pkgList <- c("plyr", "Hmisc", "reshape", "data.table")
pkgsLoaded <- pkgList %in% (.packages())
print("working1")
if(FALSE %in% pkgsLoaded) {
	install.packages(pkgList)
	lapply(pkgList, library, character.only=T)
}
rm(pkgList, pkgsLoaded)


# download data zip
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest="uciData.zip", method="curl")


# unzip into dir and docs
#unzip("uciData.zip") #creates dir <UCI HAR Dataset>


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

