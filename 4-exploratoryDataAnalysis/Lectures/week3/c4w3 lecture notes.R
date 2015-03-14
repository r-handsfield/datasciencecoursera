set.seed(1234);  # initialize random number generator

par(mar = c(0,0,0,0))  # set margins of plot window

# create a set of random points in a 2d space
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2);
y <- rnorm(12, mean = rep(c(1,2,1), each = 4), sd = 0.2);

# pch = 19 : use R pch plotting symbol #19 (blue circle)
# cex = 1  : scale plot symbols to size 1
plot(x,y, col = "blue", pch = 19, cex = 1);

# add a number, 1:12, in order, northeast of every point
text(x + 0.05, y + 0.05, labels = as.character(1:12));

df <- data.frame(x, y);
km <- kmeans(df, centers = 3);

# plot the points, colored by cluster assignment
plot(x,y, col=km$cluster, pch=19, cex=1);

# draw the cluster centers
points(km$centers, col=1:3, pch=3, cex=2, lwd=2);
