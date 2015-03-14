################################
# plot6.R
# 
# Plots total motor vehicle emissions per year in both Baltimore City 
# and Los Angeles County, to plot6.png
# 
################################

# Install ggplot2 if necessary##################
if ( !("ggplot2" %in% installed.packages()) ) {
	install.packages("ggplot2");
}

library("ggplot2");


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

print("Creating plot6.png . . .");

# Subset the nei data frame Motor Vehicle emissions rows

# Get row numbers for vehicle rows
vehicleRows <- grep(scc$SCC.Level.Two, pattern="Vehicle");

# Subset the scc vehicle rows
sccVehicle <- scc[vehicleRows, ];

# Get the SCC codes for all instances of "Vehicle"
vehicleRows <- (which(nei$SCC %in% sccVehicle$SCC));

# Get all nei rows for vehicle emissions
neiVehicle <- nei[vehicleRows, ];


# Subset rows for Baltimore and Los Angeles
baltimore <- neiVehicle[neiVehicle$fips=="24510", ];
losAngeles <- neiVehicle[neiVehicle$fips=="06037", ];

cities <- rbind(losAngeles, baltimore);
cities <- aggregate(cities$Emissions, by=list(cities$year, cities$fips), FUN = sum);
names(cities) <- c("year", "city", "emissions");

# Replace fips codes with city names
cities[cities$city=="24510", "city"] <- "Baltimore";
cities[cities$city=="06037", "city"] <- "Los Angeles";


# Build the plot

png(file="plot6.png", bg="white");

# as.factor(year) forces the x-axis labels to the data x-values
g <- ggplot(data = cities, aes(as.factor(year),emissions));
g <- g + geom_point(aes(color = city));
g <- g + geom_line(aes(group = city, color = city));
g <- g + labs(title = "Motor Vehicle Emissions: \nBaltimore and Los Angeles");
g <- g + labs(x = "Year") + labs(y = "Emissions (tons)");
print(g);

dev.off();

# Confirm success
if ("plot6.png" %in% list.files()) {
	print("Plot printed to plot6.png");
}
