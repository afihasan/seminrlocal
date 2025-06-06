% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/library.R
\name{path_weighting}
\alias{path_weighting}
\title{Inner weighting scheme functions to estimate inner paths matrix}
\usage{
path_weighting(smMatrix,construct_scores, dependant, paths_matrix)
}
\arguments{
\item{smMatrix}{is the \code{structural_model} - a source-to-target matrix representing the inner/structural model,
generated by \code{relationships}.}

\item{construct_scores}{is the matrix of construct scores generated by \code{estimate_model}.}

\item{dependant}{is the vector of dependant constructs in the model.}

\item{paths_matrix}{is the matrix of estimated path coefficients estimated by \code{estimate_model}.}
}
\value{
A matrix of estimated structural relations.
}
\description{
\code{path_factorial} and \code{path_weighting} specify the inner weighting scheme to be used in the estimation of the
inner paths matrix
}
\references{
Lohmoller, J.B. (1989). Latent variables path modeling with partial least squares. Heidelberg, Germany: Physica-Verlag.
}
