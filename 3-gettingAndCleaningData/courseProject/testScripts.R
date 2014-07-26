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
print("working2")

path <- "./UCI HAR Dataset/"
activityLabels <- read.table(paste(path,"activity_labels.txt", sep=""))
path <- "./UCI HAR Dataset/test/"
dfSubjectTest <- read.table(paste(path,"subject_test.txt", sep=""), col.names="subject")
dfXtest <- read.table(paste(path,"X_test.txt", sep=""))
dfYtest <- read.table(paste(path,"Y_test.txt", sep=""))

path <- "./UCI HAR Dataset/train/"
dfSubjectTrain <- read.table(paste(path,"subject_train.txt", sep=""), col.names="subject")
dfXtrain <- read.table(paste(path,"X_train.txt", sep=""))
dfYtrain <- read.table(paste(path,"Y_train.txt", sep=""))

rm(path)

features <- read.table("UCI HAR Dataset/features.txt", sep="\n", col.names="name")
# move row # to its own column
print("working3")
features <- colsplit(features$name, split=" ", names=c("row","name"))
# coerce feature names to characters 
features$name <- as.character(features$name)

# rows in 'features' ~ 'df_test' columns for the feature measurement
# select feature rows for mean and std measurements
fNames <- features[grepl("^.+-(mean|std)", features$name),]

# remove meanFreq() rows
l<-(c(grep("-meanFreq()", features$name)))
fNames <- fNames[which( ! fNames$row %in% l),]
rm(l)

# create the list of columns to keep
# meanStdCols <- c(fNames$row)

# select the cols for the mean and std measurements
dfXtrain.tidy <- dfXtrain[,c(fNames$row)]
dfXtest.tidy <- dfXtest[,c(fNames$row)]

# apply measurement names to the test and train DF cols
colnames(dfXtest.tidy) <- fNames$name
colnames(dfXtrain.tidy) <- fNames$name

# rename the column in the physical activity DF
colnames(dfYtest) <- "activity"
colnames(dfYtrain) <- "activity"

# get labels for the activities
labels <- as.character(activityLabels$V2)

# replace the activity codes with names of the activities
dfYtest$activity[] <- labels[dfYtest$activity[]]
dfYtrain$activity[] <- labels[dfYtrain$activity[]]

# combine all the test and all the training DFs
cbind(dfSubjectTest,dfYtest,dfXtest.tidy)->test
cbind(dfSubjectTrain,dfYtrain,dfXtrain.tidy)->train



frames.dims <- data.frame(names = c("dfSubjectTrain", " ", "dfXtrain", " ", "dfYtrain", " ", "dfSubjectTest", " ", "dfXtest", " ", "dfYtest", " "), dims = c(dim(dfSubjectTrain), dim(dfXtrain), dim(dfYtrain), dim(dfSubjectTest), dim(dfXtest), dim(dfYtest)) )


# # creates a dataframe with names of all the features
# getUciFeatures <- function(file) {
# # read in files
# features <- read.table("UCI HAR Dataset/features.txt", sep="\n", col.names="names")

# # move row # to its own column
# colsplit(features, split=" ", names=c("row","names")) -> features
# # remove the redundant row column
# features$row <- NULL

# features
# }

