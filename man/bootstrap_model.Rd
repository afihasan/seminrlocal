% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimate_bootstrap.R
\name{bootstrap_model}
\alias{bootstrap_model}
\title{seminr bootstrap_model Function}
\usage{
bootstrap_model(seminr_model, nboot = 500, cores = NULL, seed = NULL, ...)
}
\arguments{
\item{seminr_model}{A fully estimated model with associated data, measurement model and structural model}

\item{nboot}{A parameter specifying the number of bootstrap iterations to perform, default
value is 500. If 0 then no bootstrapping is performed.}

\item{cores}{A parameter specifying the maximum number of cores to use in the parallelization.}

\item{seed}{A parameter to specify the seed for reproducibility of results. Default is NULL.}

\item{...}{A list of parameters passed on to the estimation method.}
}
\value{
A list of the estimated parameters for the bootstrapped model including:
 \item{boot_paths}{An array of the `nboot` estimated bootstrap sample path coefficient matrices.}
 \item{boot_loadings}{An array of the `nboot` estimated bootstrap sample item loadings matrices.}
 \item{boot_weights}{An array of the `nboot` estimated bootstrap sample item weights matrices.}
 \item{boot_HTMT}{An array of the `nboot` estimated bootstrap sample model HTMT matrices.}
 \item{boot_total_paths}{An array of the `nboot` estimated bootstrap sample model total paths matrices.}
 \item{paths_descriptives}{A matrix of the bootstrap path coefficients and standard deviations.}
 \item{loadings_descriptives}{A matrix of the bootstrap item loadings and standard deviations.}
 \item{weights_descriptives}{A matrix of the bootstrap item weights and standard deviations.}
 \item{HTMT_descriptives}{A matrix of the bootstrap model HTMT and standard deviations.}
 \item{total_paths_descriptives}{A matrix of the bootstrap model total paths and standard deviations.}
}
\description{
The \code{seminr} package provides a natural syntax for researchers to describe PLS
structural equation models.
\code{bootstrap_model} provides the verb for bootstrapping a pls model from the model
parameters and data.
}
\examples{
data(mobi)
# seminr syntax for creating measurement model
mobi_mm <- constructs(
  composite("Image",        multi_items("IMAG", 1:5)),
  composite("Expectation",  multi_items("CUEX", 1:3)),
  composite("Value",        multi_items("PERV", 1:2)),
  composite("Satisfaction", multi_items("CUSA", 1:3)),
  interaction_term(iv = "Image", moderator = "Expectation", method = orthogonal),
  interaction_term(iv = "Image", moderator = "Value", method = orthogonal)
)

# structural model: note that name of the interactions construct should be
#  the names of its two main constructs joined by a '*' in between.
mobi_sm <- relationships(
  paths(to = "Satisfaction",
        from = c("Image", "Expectation", "Value",
                 "Image*Expectation", "Image*Value"))
)

seminr_model <- estimate_pls(data = mobi,
                             measurement_model = mobi_mm,
                             structural_model = mobi_sm)

# Load data, assemble model, and bootstrap
boot_seminr_model <- bootstrap_model(seminr_model = seminr_model,
                                     nboot = 50, cores = 2, seed = NULL)

summary(boot_seminr_model)
}
\references{
Hair, J. F., Hult, G. T. M., Ringle, C. M., and Sarstedt, M. (2017). A Primer on Partial Least Squares
 Structural Equation Modeling (PLS-SEM), 2nd Ed., Sage: Thousand Oaks.
}
\seealso{
\code{\link{relationships}} \code{\link{constructs}} \code{\link{paths}} \code{\link{interaction_term}}
}
