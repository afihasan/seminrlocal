# function to get measurement mode of a construct (first item)
measure_mode <- function(construct,mmMatrix) {
  as.matrix(mmMatrix[mmMatrix[,"construct"]==construct,"type"])[1]
}

# function to get measurement mode of a construct (first item) as a function
get_measure_mode <- function(construct,mmMatrix) {
  if((mmMatrix[mmMatrix[,"construct"]==construct,"type"][1] == "A")
     |(mmMatrix[mmMatrix[,"construct"]==construct,"type"][1] == "C")
     |(mmMatrix[mmMatrix[,"construct"]==construct,"type"][1] == "HOCA")) {
    return(mode_A)
  } else if((mmMatrix[mmMatrix[,"construct"]==construct,"type"][1] == "B")
            |(mmMatrix[mmMatrix[,"construct"]==construct,"type"][1] == "HOCB")) {
    return(mode_B)
  } else if((mmMatrix[mmMatrix[,"construct"]==construct,"type"][1] == "UNIT") ) {
    return(unit_weights)
  }
  # ifelse((mmMatrix[mmMatrix[,"construct"]==construct,"type"][1] == "A")
  #        |(mmMatrix[mmMatrix[,"construct"]==construct,"type"][1] == "C")
  #        |(mmMatrix[mmMatrix[,"construct"]==construct,"type"][1] == "HOCA"), return(mode_A), return(mode_B))
}

# Used in warnings - warning_only_causal_construct()
# function to get all the items of a given measurement mode for a given construct
items_per_mode <- function(construct, mode,mmMatrix) {
  constructmatrix <- mmMatrix[mmMatrix[,"construct"]==construct,c("measurement","type")]
  # If single item construct
  if (class(constructmatrix)[1] != "matrix") {
    constructmatrix = t(as.matrix(constructmatrix))
  }
  return(constructmatrix[constructmatrix[,"type"] == mode,"measurement"])
}

# Used in warnings - warning_only_causal_construct() and warning_single_item_formative()
# function to subset and return the mmMatrix for a construct
mmMatrix_per_construct <- function(construct, mmMatrix) {
  constructmatrix <- mmMatrix[mmMatrix[,"construct"]==construct,c("construct","measurement","type")]
  # If single item construct
  if (class(constructmatrix)[1] != "matrix") {
    constructmatrix = t(as.matrix(constructmatrix))
  }
  return(constructmatrix)
}

#' Inner weighting scheme functions to estimate inner paths matrix
#'
#' \code{path_factorial} and \code{path_weighting} specify the inner weighting scheme to be used in the estimation of the
#' inner paths matrix
#'
#' @param smMatrix is the \code{structural_model} - a source-to-target matrix representing the inner/structural model,
#'  generated by \code{relationships}.
#'
#' @param construct_scores is the matrix of construct scores generated by \code{estimate_model}.
#'
#' @param dependant is the vector of dependant constructs in the model.
#'
#' @param paths_matrix is the matrix of estimated path coefficients estimated by \code{estimate_model}.
#'
#' @return A matrix of estimated structural relations.
#' @usage
#'  path_factorial(smMatrix,construct_scores, dependant, paths_matrix)
#'
#' @references Lohmoller, J.-B. (1989). Latent variables path modeling with partial least squares. Heidelberg, Germany: Physica Verlag.
#'
#' @export
path_factorial <- function(smMatrix,construct_scores, dependant, paths_matrix) {
  inner_paths <- stats::cor(construct_scores,construct_scores) * (paths_matrix + t(paths_matrix))
  return(inner_paths)
}

#' Inner weighting scheme functions to estimate inner paths matrix
#'
#' \code{path_factorial} and \code{path_weighting} specify the inner weighting scheme to be used in the estimation of the
#' inner paths matrix
#'
#' @param smMatrix is the \code{structural_model} - a source-to-target matrix representing the inner/structural model,
#'  generated by \code{relationships}.
#'
#' @param construct_scores is the matrix of construct scores generated by \code{estimate_model}.
#'
#' @param dependant is the vector of dependant constructs in the model.
#'
#' @param paths_matrix is the matrix of estimated path coefficients estimated by \code{estimate_model}.
#' @return A matrix of estimated structural relations.
#' @usage
#'  path_weighting(smMatrix,construct_scores, dependant, paths_matrix)
#'
#' @references Lohmoller, J.B. (1989). Latent variables path modeling with partial least squares. Heidelberg, Germany: Physica-Verlag.
#'
#' @export
path_weighting <- function(smMatrix, construct_scores, dependant, paths_matrix) {
  # correlations for outgoing paths
  inner_paths <- stats::cor(construct_scores,construct_scores) * t(paths_matrix)

  #Regression betas for the incoming paths
  #Iterate and regress the incoming paths
  for (i in 1:length(dependant))  {
    #Indentify the independant variables
    independant<-smMatrix[smMatrix[,"target"]==dependant[i],"source"]

    #Solve the system of equations
    inner_paths[independant,dependant[i]] = solve(t(construct_scores[,independant]) %*% construct_scores[,independant], t(construct_scores[,independant]) %*% construct_scores[,dependant[i]])
  }
  return(inner_paths)
}

calculate_loadings <- function(weights_matrix,construct_scores, normData) {
  return(as.matrix(stats::cov(normData,construct_scores) * weights_matrix))
}

# Function to adjust for the interaction
# Adjustment of the SD of the interaction term as per Henseler, J., & Chin, W. W. (2010),
# A comparison of approaches for the analysis of interaction effects between latent variables
# using partial least squares path modeling. Structural Equation Modeling, 17(1), 82-109. https://doi.org/10.1080/10705510903439003
adjust_interaction <- function(constructs, mmMatrix, outer_loadings, construct_scores, obsData){
  for(construct in constructs) {
    adjustment <- 0
    denom <- 0
    if(grepl("\\*", construct)) {
      list <- mmMatrix[mmMatrix[,"construct"]==construct,"measurement"]

      for (item in list){
        adjustment <- adjustment + stats::sd(obsData[,item])*abs(as.numeric(outer_loadings[item,construct]))
        denom <- denom + abs(outer_loadings[item,construct])
      }
      adjustment <- adjustment/denom
      construct_scores[,construct] <- construct_scores[,construct]*adjustment
    }
  }
  return(construct_scores)

}


estimate_path_coef <- function(smMatrix, construct_scores,dependant, paths_matrix) {
  #Regression betas for the incoming paths
  #Iterate and regress the incoming paths
  for (i in 1:length(dependant))  {
    #Indentify the independant variables
    independant<-smMatrix[smMatrix[,"target"]==dependant[i],"source"]

    #Solve the system of equations
    paths_matrix[independant,dependant[i]] = solve(t(construct_scores[,independant]) %*% construct_scores[,independant], t(construct_scores[,independant]) %*% construct_scores[,dependant[i]])
  }
  return(paths_matrix)
}

standardize_outer_weights <- function(normData, mmVariables, outer_weights) {
  # Standardize the outer weights
  std_devs <- attr(scale((normData[,mmVariables]%*%outer_weights), center = FALSE),"scaled:scale")
  # divide matrix by std_devs and return
  return(t(t(outer_weights) / std_devs))
}

#' Outer weighting scheme functions to estimate construct weighting.
#'
#' \code{mode_A}, \code{correlation_weights} and \code{mode_B}, \code{regression_weights} specify the outer weighting
#' scheme to be used in the estimation of the construct weights and score.
#'
#' @param mmMatrix is the \code{measurement_model} - a source-to-target matrix representing the measurement model,
#'  generated by \code{constructs}.
#'
#' @param i is the name of the construct to be estimated.
#'
#' @param normData is the dataframe of the normalized item data.
#'
#' @param construct_scores is the matrix of construct scores generated by \code{estimate_model}.
#'
#' @return A matrix of estimated measurement model relations.
#' @usage
#'  mode_A(mmMatrix, i, normData, construct_scores)
#'
#' @aliases mode_A, correlation_weights
#'
#' @export
mode_A  <- function(mmMatrix, i, normData, construct_scores) {
    return(stats::cov(normData[,mmMatrix[mmMatrix[,"construct"]==i,"measurement"]],construct_scores[,i]))
}
#' @export
correlation_weights <- mode_A

#' Outer weighting scheme functions to estimate construct weighting.
#'
#' \code{mode_A}, \code{correlation_weights} and \code{mode_B}, \code{regression_weights} specify the outer weighting
#' scheme to be used in the estimation of the construct weights and score.
#'
#' @param mmMatrix is the \code{measurement_model} - a source-to-target matrix representing the measurement model,
#'  generated by \code{constructs}.
#'
#' @param i is the name of the construct to be estimated.
#'
#' @param normData is the dataframe of the normalized item data.
#'
#' @param construct_scores is the matrix of construct scores generated by \code{estimate_model}.
#' @return A matrix of estimated measurement model relations.
#' @usage
#'  mode_B(mmMatrix, i, normData, construct_scores)
#'
#' @aliases mode_B, regression_weights
#'
#' @export
mode_B <- function(mmMatrix, i,normData, construct_scores) {
    return(solve(stats::cor(normData[,mmMatrix[mmMatrix[,"construct"]==i,"measurement"]])) %*%
    stats::cor(normData[,mmMatrix[mmMatrix[,"construct"]==i,"measurement"]],
               construct_scores[,i]))
}
#' @export
regression_weights <- mode_B

return_only_composite_scores <- function(object){
  mm_composites <- unique(c(object$mmMatrix[which(object$mmMatrix[,3]=="A"),1],
                          object$mmMatrix[which(object$mmMatrix[,3]=="B"),1],
                          object$mmMatrix[which(object$mmMatrix[,3]=="HOCB"),1],
                          object$mmMatrix[which(object$mmMatrix[,3]=="HOCA"),1],
                          object$mmMatrix[which(object$mmMatrix[,3]=="UNIT"),1]))
  used_composites <- intersect(mm_composites, object$constructs)
  if (length(used_composites) == 0) {
      return(NULL)
  } else {
    return(object$construct_scores[, used_composites])
  }
}

# Function to return the total effects of a model
total_effects <- function(path_coef) {
  output <- path_coef
  paths <- path_coef
  while (sum(paths) > 0) {
    paths <- paths %*% path_coef
    output <- output + paths
  }
  return(output)
}

# Function to return the total indirect effects of a model
total_indirect_effects <- function(path_coef) {
  total_effects(path_coef) - path_coef
}

# Function to calculate the error covariance matrix of a PLS model
error_cov_matrix <- function(seminr_model) {
  # 1 calculate ESTIMATED item scores
  est_item_scores <- seminr_model$construct_scores %*% t(seminr_model$outer_loadings)

  # 2 collect actual std items scores (and sort)
  std_item_scores <- scale(seminr_model$data)[,colnames(est_item_scores)]

  # 3 collect item errors
  error_item_scores <- std_item_scores - est_item_scores

  # 4 get item error scores to actual scores cov matrix
  error_cov <- stats::cov(error_item_scores,std_item_scores)

  #5 get error covariances only for within block
  error_cov[(seminr_model$outer_loadings%*% t(seminr_model$outer_loadings)) == 0] <- 0

  return(error_cov)
}

get_factors <- function(seminr_model) {
  names(sapply(seminr_model$constructs,measure_mode,seminr_model$mmMatrix)[sapply(seminr_model$constructs,measure_mode,seminr_model$mmMatrix) %in% "C"])
}

get_composites <- function(seminr_model) {
  setdiff(seminr_model$constructs, get_factors(seminr_model))
}

# PURPOSE: functions to extract elements of estimated seminr models (seminr_model)

# Gets item names for a given construct in a model
items_of_construct <- function(construct, model) {
  model$mmMatrix[model$mmMatrix[,1] == construct, 2]
}

# update measurement model with interaction constructs
measure_interaction <- function(name, data, weights) {
  if (length(names(data))>1) {
    composite(name, names(data),weights = weights)
  } else {
    composite(name, colnames(data),weights = weights)
  }
}

conf_int <- function(boot_array, from, to, through = NULL, alpha = 0.05) {
  if (is.null(through)) {
    coefficient <- boot_array[from, to,]
  } else {
    coefficient <- boot_array[from, through,] * boot_array[through, to,]
  }
  quantiles <- stats::quantile(coefficient, probs = c(alpha/2,1-(alpha/2)))
  return(quantiles)
}

kurt <- function(x, na.rm = FALSE) {
   if (!is.vector(x))
     apply(x, 2, kurt, na.rm = na.rm)
   else if (is.vector(x)) {
     if (na.rm)
       x <- x[!is.na(x)]
     n <- length(x)
     n * sum((x - mean(x))^4)/(sum((x - mean(x))^2)^2)
  }
}

skew <- function(x, na.rm = FALSE) {
  if (!is.vector(x))
    apply(x, 2, skew, na.rm = na.rm)
  else if (is.vector(x)) {
    if (na.rm)
      x <- x[!is.na(x)]
    n <- length(x)
    (sum((x - mean(x))^3)/n)/(sum((x - mean(x))^2)/n)^(3/2)
  }
}

desc <- function(data, na.rm = na.rm) {
  Mean <- apply(data, 2, mean, na.rm = na.rm)
  Std.Dev. <- apply(data, 2, stats::sd, na.rm = na.rm)
  Kurtosis <- kurt(data, na.rm = na.rm)
  Min <- apply(data, 2, min, na.rm = na.rm)
  Max <- apply(data, 2, max, na.rm = na.rm)
  Median <- apply(data, 2, stats::median, na.rm = na.rm)
  Skewness <- skew(data, na.rm = na.rm)
  Missing <- apply(data, 2, function(x) sum(stats::complete.cases(x)==FALSE))
  # Missing <- attributes(data)$Missing
  # Missing <- apply(data, 2, function(x) sum(stats::complete.cases(x)==FALSE))
  No. <- 1:ncol(data)
  cbind(No., Missing, Mean, Median, Min, Max, Std.Dev., Kurtosis, Skewness)
}

mult <- function(col, iv2_data) {
  iv2_data*col
}

name_items <- function(item_name, iv2_items) {
  sapply(iv2_items, function(item2, item1 = item_name) paste(item1, item2, sep = "*"))
}

convert_to_table_output <- function(matrix) {
  class(matrix) <- append(class(matrix), "table_output")
  return(matrix)
}

constructs_in_model <- function(model) {
  construct_names <- c()
  construct_types <- c()
  if (is.null(model$hoc)) {
    for (construct in intersect(unique(model$smMatrix),unique(model$mmMatrix[,1 ]))) {
      construct_names <- c(construct_names, construct)
      construct_types <- c(construct_types, get_construct_type(model, construct))
    }
    construct_scores <- model$construct_scores
  } else {
    constructs_in_hoc_model <- intersect(unique(c(model$smMatrix, model$first_stage_model$smMatrix)),unique(model$mmMatrix[,1 ]))
    for (construct in constructs_in_hoc_model) {
      construct_names <- c(construct_names, construct)
      construct_types <- c(construct_types, get_construct_type(model, construct))

    }
    construct_scores <- cbind(model$construct_scores, model$first_stage_model$construct_scores[,setdiff(unique(model$first_stage_model$smMatrix),unique(model$smMatrix))])
  }
  return(list(construct_names = construct_names,
              construct_types = construct_types,
              construct_scores = construct_scores))
}

#' Outer weighting scheme functions to estimate construct weighting.
#'
#' \code{mode_A}, \code{correlation_weights} and \code{mode_B}, \code{regression_weights} and \code{unit_weights} specify the outer weighting
#' scheme to be used in the estimation of the construct weights and score.
#'
#' @param mmMatrix is the \code{measurement_model} - a source-to-target matrix representing the measurement model,
#'  generated by \code{constructs}.
#'
#' @param i is the name of the construct to be estimated.
#'
#' @param normData is the dataframe of the normalized item data.
#'
#' @param construct_scores is the matrix of construct scores generated by \code{estimate_model}.
#' @return A matrix of estimated measurement model relations.
#' @usage
#'  unit_weights(mmMatrix, i, normData, construct_scores)
#'
#' @export
unit_weights <- function(mmMatrix, i,normData, construct_scores) {
  # matrix(1,nrow = sum(mmMatrix[,1] == i), ncol = 1)
  return(matrix(1,nrow = sum(mmMatrix[,1] == i), ncol = 1))
}
