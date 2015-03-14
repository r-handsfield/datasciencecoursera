################################
# plo2.R 
# 
# Plots total emissions per year in Baltimore City, to plot2.png
# 
################################

# Variables for loading the source data ###############

# the data frame variables
neiDF <- "nei";
sccDF <- "scc";

# the source data files
neiFile <- "summarySCC_PM25.rds";
sccFile <- "Source_Classification_Code.rds"

dirFiles <- list.files();

# url to the source archive
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip";


# Get the nei data frame if it's missing: ############

# if the nei data frame is not in the R environment, check for the source file
if ( !(neiDF %in% ls()) ) {
	print("NEI data frame 'nei' is missing, checking for source file . . .");
	
	# if the source RDS file is also missing, check for the source archive
	if ( !( neiFile %in% dirFiles) ) {
		print("NEI source file is missing, checking for archive 'neiData.zip' . . .");
		
		# if zip archive is missing, download it
		if ( !("neiData.zip" %in% dirFiles) ) {	
			print("Source archive is missing and will be downloaded to 'neiData.zip'");
			download.file(fileUrl, destfile = "./neiData.zip", method = "curl" );	
		}
		
		else {
			print("Archive 'neiData.zip' is present and will be extracted");
		}
		
		# unzip the archive which was here, or has just downloaded
		print("Unzipping 'neiData.zip'");
		unzip("neiData.zip");	
	}
	
	# read in the nei data from the RDS file
	print("Reading nei RDS file . . .");
	nei <- readRDS("summarySCC_PM25.rds");	
	
	
}

# nei was present, or has just been created
print("NEI data frame is in variable: 'nei'");



# Get the scc data frame if it's missing: ############

# if the nei data frame is not in the R environment, check for the source file
if ( !(sccDF %in% ls()) ) {
	print("SCC data frame 'scc' is missing, checking for source file . . .");
	
	# if the source RDS file is also missing, check for the source archive
	if ( !( sccFile %in% dirFiles) ) {
		print("SCC source file is missing, checking for archive 'neiData.zip' . . .");
		
		# if zip archive is missing, download it
		if ( !("neiData.zip" %in% dirFiles) ) {
			print("Source archive is missing and will be downloaded to 'neiData.zip'");
			download.file(fileUrl, destfile = "./neiData.zip", method = "curl" );		
		}
		
		else {
			print("Archive 'neiData.zip' is present and will be extracted");
		}
		
		# unzip the archive which was here, or has just downloaded
		print("Unzipping 'neiData.zip'");
		unzip("neiData.zip");	
	}	
	
	
	# read in the nei data from the RDS file
	print("Reading scc RDS file . . .");
	scc <- readRDS("Source_Classification_Code.rds");
}
# scc was present, or has just been created
print("SCC data frame is in variable: 'scc'");

# Clean up the environment 
rm( list = c("dirFiles", "fileUrl", "neiDF", "neiFile", "sccDF", "sccFile"));
unlink("neiData.zip");



# Calculate and plot: ###################################

# sum Emissions for each year
print("Aggregating the emissions for Baltimore City . . .");

# Get emissions for every year in Baltimore
baltimore <- nei[nei$fips=="24510", ];

# Aggregate the emissions
baltimore <- aggregate(baltimore$Emissions, by=list(baltimore$year), FUN = sum);
names(baltimore) <- c("year", "emissions");

png(file="plot2.png", bg="white");

# Suppress x-axis with "xaxt = 'n'"
plot(baltimore, type = 'h', lwd = 8, col = "red", 
     xlab = "Year", ylab = "Tons", xaxt = 'n');

title(main = "Fine Particulates in Baltimore City: Total Emissions Per Year");

# Redraw x-axis with ticks at the data point locations
axis(side = 1, at = c(1999,2002,2005,2008));

dev.off();

# Confirm success
if ("plot2.png" %in% list.files()) {
	print("Plot printed to plot2.png");
}
