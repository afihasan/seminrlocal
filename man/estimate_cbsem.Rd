% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimate_cbsem.R
\name{estimate_cbsem}
\alias{estimate_cbsem}
\title{seminr estimate_cbsem() function}
\usage{
estimate_cbsem(data, measurement_model = NULL,
               structural_model = NULL, item_associations = NULL,
               model = NULL, lavaan_model = NULL, estimator = "MLR", ...)
}
\arguments{
\item{data}{A \code{dataframe} containing the indicator measurement data.

The entire CBSEM model can be specified in one of three ways:

The pair of measurement and structural models, along associated items, can optionally be specified as separate model components}

\item{measurement_model}{An optional \code{measurement_model} object representing the outer/measurement model,
as generated by \code{constructs}.
Note that only reflective constructs are supported for CBSEM models,
though a composite measurement model can be converted into a reflective one
using \code{\link{as.reflective}}.}

\item{structural_model}{An optional \code{smMatrix} object representing the inner/structural model,
as generated by \code{relationships}.}

\item{item_associations}{An item-to-item matrix representing error
  covariances that are freed for estimation.
  This matrix is created by \code{associations()}, or defaults to NULL
  (no inter-item associations).

The combination of measurement and structural models and inter-item associations can also be specified as a single \code{specified_model} object
Note that any given model components (measurement_model, structural_model, item_associations) will override components in the fully specified model}

\item{model}{An optional \code{specified_model} object containing both the the outer/measurement and inner/structural models,
  along with any inter-item associations, as generated by \code{specify_model}.

The entire model can also be specified in Lavaan syntax (this overrides any other specifications)}

\item{lavaan_model}{Optionally, a single character string containing the relevant model specification in \code{lavaan} syntax.

Any further optional parameters to alter the estimation method:}

\item{estimator}{A character string indicating which estimation method to use
in Lavaan. It defaults to "MLR" for robust estimation.
See the Lavaan documentation for other supported estimators.}

\item{...}{Any other parameters to pass to \code{lavaan::sem} during
estimation.}
}
\value{
A list of the estimated parameters for the CB-SEM model including:
 \item{data}{A matrix of the data upon which the model was estimated.}
 \item{measurement_model}{The SEMinR measurement model specification.}
 \item{factor_loadings}{The matrix of estimated factor loadings.}
 \item{associations}{A matrix of model variable associations.}
 \item{mmMatrix}{A Matrix of the measurement model relations.}
 \item{smMatrix}{A Matrix of the structural model relations.}
 \item{constructs}{A vector of the construct names.}
 \item{construct scores}{A matrix of the estimated construct scores for the CB-SEM model.}
 \item{item_weights}{A matrix of the estimated CFA item weights.}
 \item{lavaan_model}{The lavaan model syntax equivalent of the SEMinR model.}
 \item{lavaan_output}{The raw lavaan output generated after model estimation.}
}
\description{
The \code{seminr} package provides a natural syntax for researchers to describe
structural equation models.
}
\examples{
mobi <- mobi

#seminr syntax for creating measurement model
mobi_mm <- constructs(
  reflective("Image",        multi_items("IMAG", 1:5)),
  reflective("Quality",      multi_items("PERQ", 1:7)),
  reflective("Value",        multi_items("PERV", 1:2)),
  reflective("Satisfaction", multi_items("CUSA", 1:3)),
  reflective("Complaints",   single_item("CUSCO")),
  reflective("Loyalty",      multi_items("CUSL", 1:3))
)

#seminr syntax for freeing up item-item covariances
mobi_am <- associations(
  item_errors(c("PERQ1", "PERQ2"), "IMAG1")
)

#seminr syntax for creating structural model
mobi_sm <- relationships(
  paths(from = c("Image", "Quality"), to = c("Value", "Satisfaction")),
  paths(from = c("Value", "Satisfaction"), to = c("Complaints", "Loyalty")),
  paths(from = "Complaints",   to = "Loyalty")
)

# Estimate model and get results
mobi_cbsem <- estimate_cbsem(mobi, mobi_mm, mobi_sm, mobi_am)

# Use or capture the summary object for more results and metrics
summary(mobi_cbsem)

cbsem_summary <- summary(mobi_cbsem)
cbsem_summary$descriptives$correlations$constructs

}
\references{
Joreskog, K. G. (1973). A general method for estimating a linear structural equation system In: Goldberger AS, Duncan OD, editors. Structural Equation Models in the Social Sciences. New York: Seminar Press.
}
\seealso{
\code{\link{as.reflective}}
         \code{\link{relationships}} \code{\link{constructs}}
         \code{\link{paths}}
         \code{\link{associations}} \code{\link{item_errors}}
}
