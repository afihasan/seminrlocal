% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inspect_mmMatrix.R
\name{as.reflective.interaction}
\alias{as.reflective.interaction}
\title{Converts interaction of a measurement model
 into a reflective factors.}
\usage{
\method{as.reflective}{interaction}(x, ...)
}
\arguments{
\item{x}{A measurement model defined by \code{\link{constructs}}
or a single composite construct defined by \code{\link{composite}}}

\item{...}{Any further parameters for the specific construct.}
}
\value{
A list of reflective constructs.
}
\description{
Converts interaction of a measurement model
 into a reflective factors.
}
\examples{

mobi_mm <- constructs(
  composite("Image",        multi_items("IMAG", 1:5)),
  composite("Expectation",  multi_items("CUEX", 1:3)),
  composite("Value",        multi_items("PERV", 1:2))
)

new_mm <- as.reflective(mobi_mm)

}
\seealso{
\code{\link{as.reflective.measurement_model}}
}
