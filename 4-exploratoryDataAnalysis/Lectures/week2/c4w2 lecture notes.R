#Code for c4w2 Lectures

library(lattice); library(datasets);

 
## Basic lattice plotting---------------------------------
xyplot(Ozone ~ Wind, data=airquality);

## Convert 'Month' to a factor variable
airquality <- transform(airquality, Month = factor(Month));

# Use the conditioning var 'Month'
{
	# makes 5 scatter plots, 1 for each month in the set; months 5-9
	xyplot(Ozone ~ Wind | Month , data=airquality, layout = c(5,1));
	
	# if 'layout' arg is absent, lattice arranges best fit to window
	# following the order:
	# 8 9 
	# 5 6 7
}




## Lattice Functions-------------------------------------

# Create a 'Trellis' class plot object, then print it to a device.
# Many lattice PLOT functions perform both these steps (~ xyplot, bwplot, etc.) 

p <- xyplot(Ozone ~ Wind, data = airquality); ## Storing the plot = Nothing happens!
print(p); ## Plot appears




## Lattice Panel Functions-------------------------------

# Allow you to control/customize what happens in each panel

# Example: Use panel functions to show the median
{
	# 1) Create a 2-panel plot
	{
		set.seed(10); # seed for random number generator
		x <- rnorm(100); # create a normal distribution of 100 elements
		f <- rep(0:1, each=50); # a bimodal list, 50 zeroes and  50 ones
		y <- x + f - f*x + rnorm(100, sd=0.5); # create some fcn y(x)
		f <- factor(f, labels = c("Group1", "Group2")); # Convert f into factor Groups
		
		xyplot(y ~ x | f, layout = c(2,1)); # Plot the groups (G1 ~ linear, G2 ~ random)
	}
	
	# 2) Create a custom panel function to show the median
	showMedian = function(x, y, ...) {
		panel.xyplot(x, y, ...); ## First call the default panel fcn for 'xyplot' 
		panel.abline(h=median(y), lty=2); ## Draw a horizontal line (h) at the median
		# lty and other type args are often ignored by these fcns.
		# They're present to prevent parameter collisions that can happen.
	}
	
	# 3) Plot y(x), assigning our panel function to the 'panel' arg
	xyplot(y ~ x | f, panel=showMedian);
}

# Example: Use panel functions to show a regression line
{
	# Using the existing plot, define a new custom panel fcn
	showRegression <- function(x, y, ...) {
		panel.xyplot(x, y, ...); ## First call default panel function
		panel.lmline(x, y, col = 2); ## Overlay a simple linear regression line (lmline)
	}
	
	# send the function to the 'panel' arg
	xyplot(y ~ x | f, panel=showRegression);
}



## GGPlot qplot()-------------------------------

# qplot() is the basic plotting function (alias?)

# qplot(x, y = NULL, ..., data, facets = NULL, margins = FALSE,
#       geom = "auto", stat = list(NULL), position = list(NULL), xlim = c(NA,
#       NA), ylim = c(NA, NA), log = "", main = NULL, 
#	xlab = deparse(substitute(x)), ylab = deparse(substitute(y)), asp = NA)


# ggplot() is the core plotting function, and is typically used to construct a 
# plot incrementally, using the + operator to add layers to the existing ggplot 
# object. This is advantageous in that the code is explicit about which layers are 
# added and the order in which they are added. For complex graphics with multiple 
# layers, initialization with ggplot is recommended.

# ggplot(data = NULL, ...)

# Scatter plots:
{
	library(ggplot2);
	str(mpg);  # the mpg data set included with ggplot2
	
	# form: qplot(x_vector, y_vector, data = a_df )
	qplot(displ, hwy, data = mpg);
	
	# Now modify the aesthetics by
	qplot(displ, hwy, data = mpg, color = drv);
	
	# A statistic is a summary of the data, one type is a 'smoother' aka 
	# 'low S', or, in R, 'loess'
	# Add a smoother by
	qplot(displ, hwy, data = mpg, color = drv, geom = c("point", "smooth"));
	
	# Keeping the color factors (drv var) on creates 3 separate smoothing functions
	# To smooth the data as 1 series, omit the color binning.
	qplot(displ, hwy, data = mpg, geom = c("point", "smooth"));
	
	# In qplot(), geom="point" is implicit.  When we add the smoothing via the
	# geom arg, we must explicitly include the "point" attribute???
	# The blue line is the smoothing (best fit??) regression.
	# The gray region is the 95% confidence interval
		
}

# Histograms
{
	# Calling qplot with only 1 data series arg defaults to histogram
	# b/c: qplot(x, y = NULL, ...)
	
	# Plot the count of each hwy mpg value, fill the area corresponding to 
	# drv value of each measurement.
	qplot(hwy, data = mpg, fill = drv);	
	
}

# Facets - ggplot version of lattice panels
{
	# Facets (panels) default to a factor variable:
	qplot(displ, hwy, data = mpg, facets = .~drv); # drv has 3 levels
	# The facets args requires 'rows~cols', so '.~drv' shows 1 row & 3 cols;
	# 'drv~.' shows 3 rows & 1 col.
	
	# Try vertical facets with 'drv~.'
	qplot(hwy, data = mpg, facets = drv~., binwidth=2);
	
}


# GG Plot ggplot()-----------------------------

# ggplot takes arguments for 
# - the data frame
# - aesthetic mappings	color, size, etc
# - geoms			points, lines, shapes
# - facets		layouts for conditional plots
# - stats  		transforms like bins, quantiles, smoothing, etc
# - scales  		aesthetic mapping details, ex: male=red, female=blue
# - coordinate system

# Definition:
{
# 	Description: 	
# 	ggplot() initializes a ggplot object. It can be used to declare the 
# 	input data frame for a graphic and to specify the set of plot aesthetics
# 	intended to be common throughout all subsequent layers unless 
# 	specifically overridden.
# 	
# 	Usage: 	
# 	ggplot(data = NULL, ...)
# 	
# 	
# 	Arguments:
# 		data	default data set
# 		...	other arguments passed to specific methods
# 	
# 	Details: 	
# 	ggplot() is typically used to construct a plot incrementally, using 
# 	the + operator to add layers to the existing ggplot object. This is 
# 	advantageous in that the code is explicit about which layers are added 
# 	and the order in which they are added. For complex graphics with 
# 	multiple layers, initialization with ggplot is recommended.
# 	
# 	There are three common ways to invoke ggplot:
# 		ggplot(df, aes(x, y, <other aesthetics>))
# 		ggplot(df)
# 		ggplot()
	
}

# Usage:
{
	# Build up plot in layers
	
	# Saving a plot object to a var lets you call summary() on the plot:
	g <- ggplot(datafile, aes(xdata,ydata) );
	summary(g);
	# data: ...
	# mapping: x = xdata, y = ydata
	# faceting: facet_null() ## no facets yet
		
	print(g); # throws error; no layers yet!
	
	# Explicitly save the ggplot object 2/ pont layer, then print it
	p <- g + geom_point(); 
	print(p);
	
	# Auto-print w/o saving
	g + geom_point();
	
	# Then build more layers with '+'
	# Order of terms doesn't matter
	g + geom_point() + geom_smooth(); # ends of line get wide, b/c few points = low confidence = high variance
	g + geom_point() + geom_smooth(method = 'lm');
	
	# Add facets:
	g + geom_point() + facet(. ~ bmicat) + geom_smooth(method = 'lm');
	
	# Annotation:
	# use xlab(), ylab(), labs(), ggtitle
	# These can take the expression() fcn for math typesetting
	
	# For global things, use theme()
	# Defaults are theme_gray() and theme_bw();
	
	# Modifying Aesthetics:
	g + geom_point(color = "blue", size = 4, alpha = 1/2);
	# or
	g + geom_point(aes(color = factorVar), size = 4, alpha = 1/2);
	
	# Modifying a smoother:
	g + geom_point() + geom_smooth(size = 4, linetype = 3, method = "lm", se = FALSE);
	
	# Modifying Theme:
	g + geom_point() + theme_bw(base_family = "Times");
	
	# Modifying Axis Limits:
	g + geom_line() + coord_cartesian(xlim = c(-5,5),  ylim = c(-3,3));
	
	# To cut a series of non-factor data into domains or ranges, use cut():
	## Calculate deciles of the data
	cutpoints <- quantile(df$cutVar, seq(0,1, length=4), na.rm=TRUE);
	## Cut data at quartiles to create new factor variable
	df$varByDec <- cut(df$cutVar, cutpoints);
	## There is now a factor you can view by 'levels()'
	levels(df$varByDec);
	
}













