## Quiz 2 Solutions


## Question 1
##
###############################################################################
###myapp = oauth_app("github", key="", secret="")

library(httr)

# 1. Find OAuth settings for github:
# http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications
# Insert your values below - if secret is omitted, it will look it up in
# the GITHUB_CONSUMER_SECRET environmental variable.
#
# Use http://localhost:1410 as the callback url
myapp <- oauth_app("github", "0def650fd7b8a0008709", "e9802547665dc759effb19225b709231fbbfe9fb")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))
stop_for_status(req)
content(req)

y<-fromJSON(toJSON(content(req))) # this produces a corrupt df

####
## All the above is bullshit; this works:
####
json <- fromJSON("https://api.github.com/users/jtleek/repos")
json$created_at[json$name == "datasharing"] #returns the creation time for the repo named "datasharing" (index [5])




## Question 2
## Read the American Community Survey csv and use the sqldf package to
## select the 'pwgtp1' weights from rows where 'AGEP' is less than 50.
###############################################################################
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(url, dest="./acs.csv", method="curl")
acs <- read.csv("acs.csv")

# Answer
sqldf("select pwgtp1 from acs where AGEP < 50")
   # use the dims + head + tail on the result vector to confirm the answer



## Question 3
## The 'sqldf' package lets us pass mySQL commands to our mySQL installation,
## which then operates on the object we pass.  Use this package on the file
## from Question 2 to find the SQL syntax that is equivalent to the R function
## < unique(acs$AGEP) >
###############################################################################

# Answer
sqldf("select distinct AGEP from acs") 
 # in reality, need to add parameter drv='SQLite'  for this to work


## Question 4
## Count the characters in lines 10, 20, 30, 100 a web page's 
## unformatted html source.
###############################################################################
lin<-c(10,20,30,100)
nchar(ht1[lin])

[1] 45 31  7 25



## Question 5
##
###############################################################################
con <- url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for")

x <- read.fwf(file=con, skip=4, widths=c(12, 7,4, 9,4, 9,4, 9,4))

# or
x <- read.fwf(file=url("http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for"),
  skip=4, widths=c(12, 7,4, 9,4, 9,4, 9,4))

sum(x[,4])

