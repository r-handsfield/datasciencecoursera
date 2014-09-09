# plot2.R
# reads in power consumption data and plots 
# Global_active_power by day of the week
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


png(file="plot2.png");
with(powerdata, plot(Datetime, Global_active_power, type='l', xlab="", ylab="Global Active Power (kilowatts)" ))
dev.off();

