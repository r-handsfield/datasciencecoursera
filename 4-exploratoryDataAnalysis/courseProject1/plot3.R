# plot3.R
# reads in power consumption data and plots 
# sub_metering by day of the week
###########################################################

# Read only until the last datetime we want (nrows = 69516)
powerdata<-read.table(file="household_power_consumption.txt", sep=";", stringsAsFactors=FALSE, header=TRUE, nrows=69516);

# keep only the rows from Feb 1-2
both<-which(powerdata$Date=='1/2/2007' | powerdata$Date=='2/2/2007');
powerdata<-powerdata[both,];

# convert measurements to numeric
powerdata[3:9]<-apply(powerdata[3:9], MARGIN=2, FUN= as.numeric);

# combine Date and Time into a Datetime column
powerdata$Datetime<-as.POSIXlt(paste(powerdata$Date, powerdata$Time), tz="UTC", format="%d/%m/%Y %H:%M:%S")


png(file="plot3.png");
with(powerdata, plot(Datetime, Sub_metering_1, type='l', xlab="", ylab="Energy sub metering"));
with(powerdata, lines(Datetime, Sub_metering_2, col="red"));
with(powerdata, lines(Datetime, Sub_metering_3, col="blue"));
legend("topright",lwd=1, col=c("black", "blue", "red"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"));
dev.off();

