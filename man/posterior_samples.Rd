% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/posterior_samples.R
\name{posterior_samples}
\alias{posterior_samples}
\title{Extract Posterior Samples}
\usage{
posterior_samples(object, ...)
}
\arguments{
\item{object}{an object of class \code{estimate} or \code{explore}.}

\item{...}{currently ignored.}
}
\value{
A matrix of posterior samples for the partial correlation. Note that if controlling for
        variables (e.g., formula \code{~ age}), the matrix also includes the coefficients from each
        multivariate regression.
}
\description{
Extract posterior samples for all parameters.
}
\examples{
\donttest{
# note: iter = 250 for demonstrative purposes

########################################
### example 1: control  with formula ###
########################################
# (the following works with all data types)

# controlling for gender
Y <- bfi

# to control for only gender
# (remove education)
Y <- subset(Y, select = - education)

# fit model
fit <- estimate(Y, formula = ~ gender,
                iter = 250)

# note regression coefficients
samps <- posterior_samples(fit)

hist(samps[,1])
}

}
