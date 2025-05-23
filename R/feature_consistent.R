#' seminr PLSc Function
#'
#' The \code{PLSc} function calculates the consistent PLS path coefficients and loadings for
#' a common-factor model. It returns a \code{seminr_model} containing the adjusted and consistent
#' path coefficients and loadings for common-factor models and composite models.
#'
#' @param seminr_model A \code{seminr_model} containing the estimated seminr model.
#'
#' @return A SEMinR model object which has been adjusted according to PLSc.
#'
#' @usage
#' PLSc(seminr_model)
#'
#' @seealso \code{\link{relationships}} \code{\link{constructs}} \code{\link{paths}} \code{\link{interaction_term}}
#'          \code{\link{bootstrap_model}}
#'
#' @references Dijkstra, T. K., & Henseler, J. (2015). Consistent Partial Least Squares Path Modeling, 39(X).
#'
#' @examples
#' mobi <- mobi
#'
#' #seminr syntax for creating measurement model
#' mobi_mm <- constructs(
#'              reflective("Image",        multi_items("IMAG", 1:5)),
#'              reflective("Expectation",  multi_items("CUEX", 1:3)),
#'              reflective("Quality",      multi_items("PERQ", 1:7)),
#'              reflective("Value",        multi_items("PERV", 1:2)),
#'              reflective("Satisfaction", multi_items("CUSA", 1:3)),
#'              reflective("Complaints",   single_item("CUSCO")),
#'              reflective("Loyalty",      multi_items("CUSL", 1:3))
#'            )
#' #seminr syntax for creating structural model
#' mobi_sm <- relationships(
#'   paths(from = "Image",        to = c("Expectation", "Satisfaction", "Loyalty")),
#'   paths(from = "Expectation",  to = c("Quality", "Value", "Satisfaction")),
#'   paths(from = "Quality",      to = c("Value", "Satisfaction")),
#'   paths(from = "Value",        to = c("Satisfaction")),
#'   paths(from = "Satisfaction", to = c("Complaints", "Loyalty")),
#'   paths(from = "Complaints",   to = "Loyalty")
#' )
#'
#' seminr_model <- estimate_pls(data = mobi,
#'                              measurement_model = mobi_mm,
#'                              structural_model = mobi_sm)
#'
#' PLSc(seminr_model)
#' @export
PLSc <- function(seminr_model) {
  # Function to implement PLSc as per Dijkstra, T. K., & Henseler, J. (2015). Consistent Partial Least Squares Path Modeling, 39(X).
  # get relevant parts of the estimated model
  smMatrix <- seminr_model$smMatrix
  mmMatrix <- seminr_model$mmMatrix
  path_coef <- seminr_model$path_coef
  loadings <- seminr_model$outer_loadings
  rSquared <- seminr_model$rSquared
  construct_scores <- seminr_model$construct_scores
  constructs_in_model(seminr_model)$construct_names
  # Calculate rho_A for adjustments and adjust the correlation matrix
  rho <- rho_A(seminr_model,constructs_in_model(seminr_model)$construct_names)
  ### Coerce interactions to rhoA of 1
  rho[grepl("\\*", rownames(rho)), ] <- 1
  adjustment <- sqrt(rho %*% t(rho))
  diag(adjustment) <- 1
  adj_construct_score_cors <- stats::cor(seminr_model$construct_scores) / adjustment

  # iterate over endogenous constructs and adjust path coefficients and R-squared
  for (i in all_endogenous(smMatrix)) {

    #Indentify the exogenous variables
    exogenous <- smMatrix[smMatrix[, "target"]==i, "source"]

    #Solve the system of equations
    results <- solve(adj_construct_score_cors[exogenous, exogenous],
                    adj_construct_score_cors[exogenous, i])
    # Assign the path names
    names(results) <- exogenous

    #Assign the Beta Values to the Path Coefficient Matrix
    path_coef[exogenous, i] <- results
  }

  #calculate insample metrics
  rSquared <- calc_insample(seminr_model$data, construct_scores, smMatrix, all_endogenous(smMatrix), adj_construct_score_cors)

  # get all common-factor constructs (Mode A Consistent) in a vector
  reflectives <- intersect(all_reflective(mmMatrix), construct_names(seminr_model$smMatrix))

  # function to adjust the loadings of a common-factor
  adjust_loadings <- function(i) {
    w <- as.matrix(seminr_model$outer_weights[mmMatrix[mmMatrix[, "construct"]==i, "measurement"], i])
    loadings[mmMatrix[mmMatrix[,"construct"]==i,"measurement"], i] <- w %*% (sqrt(rho[i, ]) / t(w) %*% w )
    loadings[, i]
  }

  # apply the function over common-factors and assign to loadings matrix
  if(length(reflectives) > 0) {
    loadings[, reflectives] <- sapply(reflectives, adjust_loadings)
  }

  # Assign the adjusted values for return
  seminr_model$path_coef <- path_coef
  seminr_model$outer_loadings <- loadings
  seminr_model$rSquared <- rSquared
  return(seminr_model)
}

# Function to implement PLSc as per Dijkstra, T. K., & Henseler, J. (2015). Consistent Partial Least Squares Path Modeling, 39(X).
model_consistent <- function(seminr_model) {
  if(!is.null(seminr_model$interactions) && ("C" %in% seminr_model$mmMatrix[, "type"])) {
    message(
      "Models with interactions can be estimated as PLS consistent, but are subject to some bias as per Becker et al. (2018)\n",
      "'Estimating Moderating Effects in PLS-SEM and PLSc-SEM: Interaction Term Generation*Data Treatment'")
    seminr_model <- PLSc(seminr_model)
  }
  if(is.null(seminr_model$interactions) && ("C" %in% seminr_model$mmMatrix[, "type"])) {
    seminr_model <- PLSc(seminr_model)
  }
  return(seminr_model)
}
