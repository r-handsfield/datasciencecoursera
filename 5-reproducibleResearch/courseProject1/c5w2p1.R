df <- read.csv("./activity.csv");


for (i in 1:nrow(tmp)) {
	itm <- tmp[i,"itm"];
	theAvg <- stepAvg[which(stepAvg$interval==itm),"steps"];
	tmp$steps[i] <- theAvg;
}
