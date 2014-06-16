# to find R packages for all file types, google 'data storage mechanism R package'


## Downloading data from the web
## SOURCE = c3w1L4
#############################################################

## Downloading data (from httpS requires curl)

## Download a csv from the American Community Database
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv "
download.file(fileUrl, destfile = "./acs.csv", method = "curl" )

## Always store the date you saved the data
dateDownloaded <- date()


## MySQL data
## SOURCE = c3w2L1
#############################################################

## Getting data from the ucsc genome database ()
 # MySQL must be installed and added to PATH
 # then . . . 
install.packages("RMySQL")
library("RMySQL")
ucscDb <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu") # connects to all DBs at host
result  <- dbGetQuery(ucscDb, "show databases;"); dbDisconnect(ucscDb);
## above returns a boolean
result # displays all the databases ("show databases" is the mysql command that we send)

## connect to the hg19 database
hg19 <- dbConnect(MySQL(), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")

## store all table names in hg19
allTables <- dbListTables(hg19)

## how many tables are there?
length(allTables)

## what are the fields in the "affyU133Plus2" table?
dbListFields(hg19, "affyU133Plus2")

## pass a query to the table 'affyU133Plus2'
dbGetQuery(hg19, "SELECT COUNT(*) FROM affyU133Plus2")

## read the table (big operation) into a data.frame
affyData <- dbReadTable(hg19, "affyU133Plus2")

## to avoid reading the whole table, send a mysql query & store results in a data.frame
query <- dbSendQuery(hg19, "SELECT * FROM affyU133Plus2 WHERE misMatches BETWEEN 1 AND 3")
affyMis <- fetch(query); 

## break the misMatch column into quintiles
quantile(affyMis$misMatches) 

## limit rows, when you need to skim data, then clear the query (returns boolean)
affyMisSmall <- fetch(query, n=10); dbClearResult(query);

## close the DB connection
dbDisconnect(hg19)


## The sqldf package (often requires parameter 'drv="SQLite"' to work)




## hdf5 files
## SOURCE = c3w2L2
##
## The HDF group has base info on the rhdf5 package
## In general, hdf5 can optimize disk read/write operations
#############################################################

library(rhdf5)
created = h5createFile("example.h5")
created # returns only <[1] TRUE> b/c the file is empty

## create groups in the file 
created = h5createGroup("example.h5", "foo")
created = h5createGroup("example.h5", "baa")
created = h5createGroup("example.h5", "foo/foobaa")

## list the contents of the h5 file	
h5ls("example.h5") 

## create data and add it to the group "foo"
A = matrix(1:10,nr=5,nc=2)
h5write(A, "example.h5","foo/A")

## create 2 arrays 
B = array(seq(.1,2,by=.1), dim=c(5,2,2))
## add metadata to the arrays
attr(B, "scale") <- "liter"
## add the arrays to the subgroup "foobaa"
h5write(B, "example.h5","foo/foobaa/B")

## create a data frame and add it to the h5 file "example.h5"
df = data.frame(1L:5L, seq(0,1,length.out=5), c("ab","cde","fghi","a","s"), stringsAsFactors=FALSE)
h5write(df, "example.h5","df")

## list the contents of the h5 file
h5ls("example.h5")

## read individual datasets from the file into [r] variables
readA = h5read("example.h5","foo/A")
readB = h5read("example.h5","foo/foobaa/B")
readdf = h5read("example.h5","df")

## change the first 3 values of the matrix 'A' in the h5 file
h5write(c(12,13,14), "example.h5","foo/A", index=list(1:3,1))



## Web Scraping
## SOURCE = c3w2L3
##
## Can be against website terms of service
## Reading too many pages too quickly will get your IP blocked
##
## See 'R Bloggers' for great examples
##  also check the <httr> help file from cran
##############################################################

## read source from a url
 # open a connection
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
 # store the text source in a 'character' variable
 # this command throws a warning if the source does not end in a <newline>
htmlCode = readLines(con)
 # close the connection
close(con)

## the source is unformatted, we can parse it with the 'XML' package
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=TRUE) # this stores as formatted html of type 'XMLInternalDocument'

## this extracts the inner html from the <title> inner html </title> tag
xpathSApply(html, "//title", xmlValue)

## this extracts the number of times each paper has been cited
##  by extracting from all instances of <td id='col-citedby'> inner html </td>
xpathSApply(html, "//td[@id='col-citedby']", xmlValue)


## We can also scrape webpages with the "httr" package
##  this package is better for sites that need authentication
library(httr)

url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"

html2 = GET(url) #html2 is a member of the 'response' class

 # 'html2' includes headers, cookies, and other meta + attributes
 names(html2)

 # coerce the source to 'character'
content2 = content(html2, as="text") # content2 is the source coerced to 'character'

parsedHtml = htmlParse(content2, asText=TRUE) # this is now formatted, and is of class 'XMLInternalDocument'

xpathSApply(parsedHtml,"//title",xmlValue) # this still scrapes from <title> </title>

## Now scraping from a password-protected page
html = GET("http://_a_url", authenticate("user","password")) #returns a JSON obj w/ authentication status + username

 # to preserve authentication for multiple scrapes, use a handle
 google = handle("http://google.com")

 # store the source of the root or ~index.html of google
 pg1 = GET(handle=google, path='/')

 # store the source of google's search page
 pg2 = GET(handle=google, path='search')




