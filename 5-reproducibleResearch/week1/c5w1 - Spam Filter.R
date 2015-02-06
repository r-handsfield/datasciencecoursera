# Structure of a data set part 2, c5w1 Lecture
# Use R to write a spam filter
# see notes: "3 - Structure of a Data Analysis part 2.pdf"
#
# raw data documentation: https://archive.ics.uci.edu/ml/datasets/Spambase
# package documentation : http://search.r-project.org/library/kernlab/


#install the kernlab package to access the the 'spam' dataset
install.packages("kernlab");
library(kernlab);

# spam is a data set collected at Hewlett-Packard Labs, that classifies
# 4601 e-mails as spam or non-spam. In addition to this class label
# there are 57 variables indicating the frequency of certain words
# and characters in the e-mail.

# load spam into the environment
data(spam);

# Split the data into 2 separate sets, a test set and training set.
# Training set builds the model, Test set determines how good the model is.


# Create a random, binary distribution, the same size as 'spam' (4601)
set.seed(3435);
trainIndicator = rbinom(n = 4601, size = 1, prob = 0.5);

# Subset spam by row
trainSpam = spam[trainIndicator == 1, ];
testSpam = spam[trainIndicator == 0, ];

# names(trainSpam);
# head(trainSpam);

## Each col is a word appearing in an email; each row is the percentage
## frequency of the word in 1 email.
## We care about the 'type' column (58), a "spam"/"nonspam" factor


# A data frame with 4601 observations and 58 variables.
#
# The first 48 variables contain the frequency percentage of the variable name (e.g., business)
# in the e-mail. If the variable name starts with num (e.g., num650) the it indicates
# the frequency of the corresponding number (e.g., 650). The variables 49-54 indicate
# the frequency of the characters ;, (, [, !, $, and #. The variables
# 55-57 contain the average, longest and total run-length of capital letters. Variable
# 58 indicates the type of the mail and is either "nonspam" or "spam", i.e. unsolicited
# commercial e-mail.


# Plan
# 1 - cluster the data to explore it

plot(trainSpam$capitalAve ~ trainSpam$type);
# The average num of capital letters is higher in spam email.
# This comparison is highly skewed, Cap avg is much higher in spam than non.
# In these cases, it's useful to look at the log10 plot.

# plot the log10 transformation of the y variable
plot(log10(trainSpam$capitalAve + 1) ~ trainSpam$type); # add 1 to Caps b/c log(0) -> -Inf
# yep, the frq is much, much higher in spam

#look at several pairwise relationships - words "make", "address", "all", "num3d"
plot(log10(trainSpam[,1:4] + 1)); # cols = x-axis, rows = y-axis
# make+address, make+all, make+num3d, address+num3d, are log-log corelated

# explore the predictor space via a hierarchical cluster analysis
#  - shows which vars tend to cluster together
hCluster = hclust(dist(t(trainSpam[, 1:57])));
plot(hCluster);
# Right now, this only separates out the capitalTotal var; not very useful.
# Cluster algorithms can be sensitive to skewness in the vars (which this has).

# Lets try again with the log of the data.
hClusterUpdated = hclust(dist(t(log10(trainSpam[, 1:55] + 1))));
plot(hClusterUpdated);
# The capitalAve doesn't really cluster with anything.
# You, will, and your, tend to cluster together, but not with anything else
# num857, num415, cluster the tightest.
# Many groups/pairs at the bottom cluster closely.


# Can we predict spam from a single variable?
# Create a basic statistical model:
# Go through the first 55 vars and try to fit a generalized linear model,
# in this case a logistic regression to the spam type.

trainSpam$numType = as.numeric(trainSpam$type) - 1; #add a boolean col of 1=spam, 0=nonspam
costFunction = function(x,y) sum(x != (y > 0.5)); # returns FALSE when x==1, TRUE otherwise
cvError = rep(NA, 55); #initialize a vector for the cross-validation error

# install the package for generating R bootstrap replicates of a statistic applied to data
install.packages("boot");
library(boot);


for (i in 1:55) {
	# create a formula that includes the response, and 1 of the vars in spam
	lmFormula = reformulate(names(trainSpam)[i], response = "numType");

	# generate the generalized linear model
	glmFit = glm(lmFormula, family = "binomial", data = trainSpam);

	# calculate the estimated K-fold cross-validation prediction error
	cvError[i] = cv.glm(trainSpam, glmFit, costFunction, 2)$delta[2];
}

# The best var will have the lowest K-fold cross-validation prediction error
names(trainSpam)[which.min(cvError)];

## Result is "charDollar".  The '$' is the best predictor of spam.
plot(log10(trainSpam$charDollar + 1) ~ trainSpam$type);


# Test the model . . .

# Generate a model using the best predictor: charDollar.
predictionModel = glm(numType ~ charDollar, family = "binomial", data = trainSpam);

# Test the model on the test set: testSpam.
predictionTest = predict(predictionModel, testSpam); #returns a ~struct of predictions from running the training model on the test set
# predictionModel$fitted contains probabilities that a message is spam based on frq of '$'

predictedSpam = rep("nonspam", dim(testSpam)[1]); # initialize a vector for predicted spam

# Overwrite 'nonspam' with 'spam' when probability is greater than 50%
predictedSpam[predictionModel$fitted > 0.5] = "spam";


table(predictedSpam, testSpam$type);
# Output:
#
# predictedSpam  nonspam  spam
#
#       nonspam     1346   458   ## row2 = the total nonspams predicted by model
#
#       spam        61     449   ## row2 = the total spams predicted by model
#			   ## col2 = the total spams in the test set testSpam
#		    ## col1 = the total nonspams in the test set testSpam

# Decoded:
#
# predictedSpam  nonspam  spam   ## (spam = positive, nonspam = negative)
#
#       nonspam       tn    fn   ## true negative, false negative (1346, 458)
#
#       spam          fp    tp   ## false positive, true positive (  61, 449)

# Error rate:
# (false pos + false neg) / (total observations)
#
  (61 + 458)/(1346 +458 + 61 + 449);
# [1] 0.2242869  ## 22% error rate









