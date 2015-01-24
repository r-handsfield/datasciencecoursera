# plot1.R
# reads in power consumption data and plots a histogram
# of Global_active_power
###########################################################

# Read only until the last datetime we want (nrows = 69516)
powerdata<-read.table(file="household_power_consumption.txt", sep=";", stringsAsFactors=TRUE, header=TRUE, nrows=69516);

# keep only the rows from Feb 1-2
both<-which(powerdata$Date=='1/2/2007' | powerdata$Date=='2/2/2007');
powerdata<-powerdata[both,];

#powerdata[,1]<-as.Date(powerdata[,1], format="%d/%m/%Y");
powerdata[3:9]<-apply(powerdata[3:9], MARGIN=2, FUN= as.numeric);

png(file="plot1.png", bg="white");
with(powerdata, hist(Global_active_power, col="red", breaks=12, xlab="Global Active Power (kilowatts)", main="Global Active Power" ));
dev.off();


# #Keep rows from 2007-02-01 and 2007-02-02 via
# tmp<-which(txt$Date=='1/2/2007')
# first = tmp[1]
# last = tmp[1]+length(tmp)-1
# 66637 - 68076
# 
# tmp<-which(txt$Date=='2/2/2007')
# first = tmp[1]
# last = tmp[1]+length(tmp)-1
# 68077 - 69516

