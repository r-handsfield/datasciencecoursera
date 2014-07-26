# Question 1
# The American Community Survey distributes downloadable data 
# about United States communities. Download the 2006 microdata 
# survey about housing for the state of Idaho using download.file() 
# from here: 

# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
setwd("datasciencecoursera/3-gettingAndCleaningData/quiz3/")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "IdahoHousing.csv")
df<-read.csv("IdahoHousing.csv")

# and load the data into R. The code book, describing the variable names is here: 

# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 

# Create a logical vector that identifies the households on greater than 10 acres 
# who sold more than $10,000 worth of agriculture products. Assign that logical 
# vector to the variable agricultureLogical. 
// Lot size (acres) in column 'ACR'; value 3 = 10+ acres
// Sales of agriculture products in column 'AGS'; value 6 = $10k+

agricultureLogical<-(df$ACR==3 & df$AGS==6)

# Apply the which() function like this to identify the rows of the data frame where 
# the logical vector is TRUE. 

which(agricultureLogical)
 [1]  125  238  262  470  555  568  608  643  787  808  824  849  952  955 1033
[16] 1265 1275 1315 1388 1607 1629 1651 1856 1919 2101 2194 2403 2443 2539 2580
[31] 2655 2680 2740 2838 2965 3131 3133 3163 3291 3370 3402 3585 3652 3852 3862
[46] 3912 4023 4045 4107 4113 4117 4185 4198 4310 4343 4354 4448 4453 4461 4718
[61] 4817 4835 4910 5140 5199 5236 5326 5417 5531 5574 5894 6033 6044 6089 6275
[76] 6376 6420

# which(agricultureLogical) What are the first 3 values of that result?
Answer 125, 238, 262 (D)
# -----------------------------------------------------------------------------------


# Question 2
# Using the jpeg package read in the following picture of your instructor into R 

# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", "getdata-jeff.jpg") 

# Use the parameter native=TRUE. 
jpg<-readJPEG(source="getdata-jeff.jpg", native=TRUE)
# What are the 30th and 80th quantiles of the resulting data? 
# (some Linux systems may produce an answer 638 different for the 30th quantile)

quantile(jpg, probs=seq(0,1,.1))
       0%       10%       20%       30%       40%       50%       60% 
-16776430 -15787693 -15518834 -15259150 -14927764 -14191406 -12363904 
      70%       80%       90%      100% 
-11297076 -10575416  -5057565   -594524 

Answer: -15259150, -10575416 (B)
# -----------------------------------------------------------------------------------


# Question 3
# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
//A lot of dicking up shows that gdp csv is badly formatted, and read as chars
//Gotta select which lines to read, then convert chars to nums

# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv","getdata-data-GDP.csv")
gdp<-read.csv("getdata-data-GDP.csv")

gdp<-read.csv("getdata-data-GDP.csv", header=FALSE, skip=5, nrows=230,
		col.names=c("CountryCode", "gdpRank", "V3", "name", "gdp", "notes", "V7", "V8", "V9","V10"),		
	     )


gdp<-gdp[,c(1:2,4:6)]
//tail(gdp[order(gdp$gdpRank, na.last=FALSE,decreasing=TRUE),])
# Load the educational data from this data set: 

# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv","getdata-data-EDSTATS_Country.csv")
ed<-read.csv("getdata-data-EDSTATS_Country.csv")


# Match the data based on the country shortcode. 
//gdp country shortcode is in named gdp column 'CountryCode'
//ed shortcode is in ed column "CountryCode"

df<-merge(gdp, ed, by="CountryCode", all.x=TRUE, all.y=TRUE)

# How many of the IDs match? 
!(ed[,1] %in% gdp[,1])->missing; count(ed[missing,1]);

!(gdp[,1] %in% ed[,1])->missing; count(gdp[missing,1]);
//gdp has 4 unique countries, ed has 11


# Sort the data frame in descending order by GDP rank (so United States is last). 
head(gdp)
//Rank is in named col df$gdpRank
df<- plyr::arrange(df, df$gdpRank, na.last=TRUE, decreasing=TRUE)
df<- plyr::arrange(df, df$gdpRank, na.last=TRUE, decreasing=TRUE)


# What is the 13th country in the resulting data frame? 
178, St. Kitts and Nevis

# Original data sources: 
# http://data.worldbank.org/data-catalog/GDP-ranking-table 
# http://data.worldbank.org/data-catalog/ed-stats


# Question 4
# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
//col ed$Income.Group == "High income: OECD" && "High income: nonOECD"

# Question 5
# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many 
# countries are Lower middle income but among the 38 nations with highest GDP?