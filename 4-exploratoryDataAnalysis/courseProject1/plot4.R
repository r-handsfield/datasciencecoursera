# plot4.R
# reads in power consumption data and plots 
# a bunch of stuff
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


png(file="plot4.png", bg="white");
par(mfrow = c(2,2));

# top left
with(powerdata, plot(Datetime, Global_active_power, type='l', xlab="", ylab="Global Active Power" ));

# top right
with(powerdata, plot(Datetime, Voltage, type='l', xlab="datetime", ylab="Voltage" ));

# bottom left
with(powerdata, plot(Datetime, Sub_metering_1, type='l', xlab="", ylab="Energy sub metering"));
with(powerdata, lines(Datetime, Sub_metering_2, col="red"));
with(powerdata, lines(Datetime, Sub_metering_3, col="blue"));
legend("topright",lwd=1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n");

# bottom right
with(powerdata, plot(Datetime, Global_reactive_power, type='l', xlab="datetime", ylab="Global_reactive_power"));

dev.off();

#with(powerdata, plot(Datetime, Global_active_power, type='l', xlab="", ylab="Global Active Power (kilowatts)" ))
