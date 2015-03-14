################################
# plo5.R
# 
# Plots total motor vehicle emissions 
# per year in Baltimore City, to plot5.png
# 
################################

# Install plyr if necessary##################
if ( !("plyr" %in% installed.packages()) ) {
	install.packages("plyr");
}

library("plyr");


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

print("Creating plot5.png . . .");
# Find the SCC codes for motor vehicle emissions

# Find any columns containing "Vehicle"
isVehicle <- function(x) { 
	smm <- grep(x, pattern="Vehicle"); 
	
	# returns TRUE if "Vehicle" is in the col
	sum(smm) > 0;
}

# apply to every col in df
cols <- colwise(isVehicle)(scc);

# Get var names containing "Vehicle"
# names(scc[ , which(cols == TRUE)]);

# # Verify cols with grep
# length(grep(scc$Short.Name, pattern="Vehicle") )
# # [1] 260
# length(grep(scc$EI.Sector, pattern="Vehicle") )
# # [1] 1138
# length(grep(scc$SCC.Level.Two, pattern="Vehicle") )
# # [1] 1452
# length(grep(scc$SCC.Level.Three, pattern="Vehicle") )
# # [1] 552
# length(grep(scc$SCC.Level.Four, pattern="Vehicle") )
# # [1] 24


# EI.Sector and SCC.Level.Two have the most entries, look at those first
# using the names, look at unique values:

# unique(scc[(grep(scc$EI.Sector, pattern="Vehicle")), "EI.Sector"]);
# unique(scc[(grep(scc$SCC.Level.Two, pattern="Vehicle")), "SCC.Level.Two"]);


# SCC.Level.Two seems like the best descriptor for motor vehicle use.

# Get row numbers for vehicle rows
vehicleRows <- grep(scc$SCC.Level.Two, pattern="Vehicle");

# Subset the scc vehicle rows
sccVehicle <- scc[vehicleRows, ];

# Get the SCC codes for all instances of "Vehicle"
vehicleRows <- (which(nei$SCC %in% sccVehicle$SCC));

# Get all nei rows for vehicle emissions
neiVehicle <- nei[vehicleRows, ];

# Subset the nei vehicle emissions measured in Baltimore
baltimore <- neiVehicle[neiVehicle$fips=="24510", ];
baltimore <- aggregate(baltimore$Emissions, by=list(baltimore$year), FUN = sum);
names(baltimore) <- c("year", "emissions");

# Build the plot


png(file="plot5.png", bg="white");

plot(baltimore, type = 'h', lwd = 8, col = "red", 
     xlab = "Year", ylab = "Tons", xaxt = 'n');

# Redraw x-axis with ticks at the data point locations
axis(side = 1, at = c(1999,2002,2005,2008));

title(main = "Annual Emissions from \nMotor Vehicles in Baltimore");

dev.off();


# Confirm success
if ("plot5.png" %in% list.files()) {
	print("Plot printed to plot5.png");
}
