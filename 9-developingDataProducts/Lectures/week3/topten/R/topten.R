# topten.R
# builds a predictor based on top 10 features
# Uses roxygen2 documentation package, denote doc strings with #'

#' Building a Model with Top Ten Features
#' 
#' This function develops a prediction algorithm based on the top 10 features in 
#' 'x' that are most predictive of 'y'.
#' 
#' @param x a n x p matrix of n observation and p predictors
#' @param y a vector of length n representing the response
#' @return a vector of coefficients from the final fitted model with top 10 features
#' 
#' @author Roger Peng
#' @details
#' This function runs a univariate regression of y on each predictor in x and
#' calclulates a p-value indicating the significance of the association. The
#' final sef of 10 predictors is taken from the 10 smallest p-values.
#' 
#' @seealso \code{lm}
#' @export
#' @importFrom stats lm

topten <- function (x, y) {
	p <- ncol(x)
	if (p < 10)
		stop("There are less than 10 predictors")
	
	pvalues <- numeric(p)
	for (i in seq_len(p)) { # find the best fit coefficient for each predictor
		fit <- lm(y ~ x[,i])
		summ <- summary(fit)
		pvalues[i] <- summ$coefficients[2,4]
	}
	
	# order pvalues ascending
	ord <- order(pvalues)[1:10]
	x10 <- x[, ord]
	
	# refit the model with only the top 10 predictors
	fit <- lm(y ~ x10)
	coef(fit)
}


#' Prediction with the Top Ten features
#' 
#' This function takes a set of coefficients produced by the \code{topten} 
#' function and makes a prediction for each of the values provided in the 
#' input 'X' matrix.
#'
#' @param X a n x 10 matrix containing n new observation 
#' @param b a vector of coefficients obtained from the \code{topten} function 
#' @return  a numeric vector containing the predicted values
#' @export


predict10 <- function(X, b) {
	X <- cbind(1, X) # add intercept to data matrix
	
	# matrix product
	drop(X %*% b) # returns a vector of predictions
}