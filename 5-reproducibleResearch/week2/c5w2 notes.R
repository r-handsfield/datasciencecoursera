# c5w2 Lecture notes

# Coding Standards------------------------------------
# 1) Always use a text editor
# 2) Indent your code
# 3) Limit your code width (to ~80 columns)
#    - improves readability, dissuades nesting & long functions, 4-8 spaces suggested
# 4) Limit the length of individual functions


# R Markdown Syntax--------------------------------------------

# 	*italic*
# 	**bold**

	#Heading 1
	##Heading 2
	###Heading 3

# 	- unordered list item
# 	2. ordered list item ('2.' is any number)

# 	Links:
	{
# 		[text](target url)
#
# 		Organized Linking:
# 		These are [some][1] [links][2].
# 			[1]: target url  "some"
# 			[2]: target url  "links"
	}

# 	Newlines:
	{
# 		Newlines require a double whitespace at end of line.
# 		Line 1"  "  #quotes added for demonstration
# 		Line 2
	}

#	R Code:
	{
		Block:
		```{r nameOfChunk, params}

		``` #end chunk

		Inline:
		`r mean(x)` . . .

		Block Display only, don't evaluate:     '
		``` code here ```

		Inline display only:
		`code here`
	}


# knitr-----------------------------------------------

# R md is converted to standard md by knitr (or sweave??)
# R has a 'markdown' package for md -> html
# The 'slidify' packages converts R md to slides (pdf or ppt??)

# set cache=TRUE to cache individual chunks - may give errors if preceding code changes

# Manually, use these commands to knit a doc:
{
	library(knitr);
	setwd("./");
	knit2html("myFile.Rmd");
	browseURL("myFile.html");
}

# Setting global options
{
	At the beginning of your Rmd, create a block like this:
		```{r setoptions, echo=FALSE}
		opts_chunk$set(echo = FALSE, results = "hide", ~option = value )
		```
}




# Literate Statistical Programming--------------------





























