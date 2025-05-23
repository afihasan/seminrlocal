context("SEMinR correctly estimates rho_A for the simple model\n")

# Test cases
## Simple case
# seminr syntax for creating measurement model
mobi_mm <- constructs(
  reflective("Image",        multi_items("IMAG", 1:5)),
  reflective("Expectation",  multi_items("CUEX", 1:3)),
  reflective("Value",        multi_items("PERV", 1:2)),
  reflective("Satisfaction", multi_items("CUSA", 1:3))
)

# structural model: note that name of the interactions construct should be
#  the names of its two main constructs joined by a '*' in between.
mobi_sm <- relationships(
  paths(to = "Satisfaction",
        from = c("Image", "Expectation", "Value"))
)

# Load data, assemble model, and estimate using semPLS
seminr_model <- estimate_pls(mobi, mobi_mm, mobi_sm,inner_weights = path_factorial)


# Load outputs
rho <- rho_A(seminr_model, constructs_in_model(seminr_model)$construct_names)

## Output originally created using following lines
# write.csv(rho, file = "tests/fixtures/rho1.csv")

# Load controls
rho_control <- as.matrix(read.csv(file = paste(test_folder,"rho1.csv", sep = ""), row.names = 1))

# Testing

test_that("Seminr estimates rhoA correctly\n", {
  expect_equal(rho, rho_control, tolerance = 0.00001)
})

context("SEMinR correctly estimates rhoA for the interaction model\n")

# Test cases
## Interaction case

# seminr syntax for creating measurement model
mobi_mm <- constructs(
  reflective("Image",        multi_items("IMAG", 1:5)),
  reflective("Expectation",  multi_items("CUEX", 1:3)),
  reflective("Value",        multi_items("PERV", 1:2)),
  reflective("Satisfaction", multi_items("CUSA", 1:3)),
  interaction_term(iv = "Image", moderator = "Expectation", method = orthogonal, weights = mode_A),
  interaction_term(iv = "Image", moderator = "Value", method = orthogonal, weights = mode_A)
)

# structural model: note that name of the interactions construct should be
#  the names of its two main constructs joined by a '*' in between.
mobi_sm <- relationships(
  paths(to = "Satisfaction",
        from = c("Image", "Expectation", "Value",
                 "Image*Expectation", "Image*Value"))
)

# Load data, assemble model, and estimate using semPLS
seminr_model <- estimate_pls(mobi, mobi_mm, mobi_sm,inner_weights = path_factorial)

# Load outputs
rho <- rho_A(seminr_model, constructs_in_model(seminr_model)$construct_names)

## Output originally created using following lines
## write.csv(rho, file = "tests/fixtures/rho2.csv")

# Load controls
rho_control <- as.matrix(read.csv(file = paste(test_folder,"rho2.csv", sep = ""), row.names = 1))

# Testing

test_that("Seminr estimates rho_A correctly\n", {
  expect_equal(rho, rho_control, tolerance = 0.00001)
})

context("SEMinR correctly estimates PLSc path coefficients, rsquared and loadings for the simple model\n")

# Test cases
## Simple case
# seminr syntax for creating measurement model
mobi_mm <- constructs(
  reflective("Image",        multi_items("IMAG", 1:5)),
  reflective("Expectation",  multi_items("CUEX", 1:3)),
  reflective("Value",        multi_items("PERV", 1:2)),
  reflective("Satisfaction", multi_items("CUSA", 1:3))
)

# structural model: note that name of the interactions construct should be
#  the names of its two main constructs joined by a '*' in between.
mobi_sm <- relationships(
  paths(to = "Satisfaction",
        from = c("Image", "Expectation", "Value"))
)

# Load data, assemble model, and estimate using semPLS
seminr_model <- estimate_pls(mobi, mobi_mm, mobi_sm,inner_weights = path_factorial)
# plscModel <- PLSc(seminr_model)

# Load outputs
path_coef <- seminr_model$path_coef
loadings <- seminr_model$outer_loadings
rSquared <- seminr_model$rSquared

## Output originally created using following lines
# write.csv(path_coef, file = "tests/fixtures/path_coef1.csv")
# write.csv(loadings, file = "tests/fixtures/loadings1.csv")
# write.csv(rSquared, file = "tests/fixtures/rsquaredplsc.csv")


# Load controls
path_coef_control <- as.matrix(read.csv(file = paste(test_folder,"path_coef1.csv", sep = ""), row.names = 1))
loadings_control <- as.matrix(read.csv(file = paste(test_folder,"loadings1.csv", sep = ""), row.names = 1))
rSquared_control <- as.matrix(read.csv(file = paste(test_folder,"rsquaredplsc.csv", sep = ""), row.names = 1))

# Testing

test_that("Seminr estimates PLSc path coefficients correctly\n", {
  expect_equal(path_coef, path_coef_control, tolerance = 0.00001)
})

test_that("Seminr estimates PLSc loadings correctly\n", {
  expect_equal(loadings[,1:4], loadings_control, tolerance = 0.00001)
})

test_that("Seminr estimates rsquared  correctly\n", {
  # remove BIC for now
  #expect_equal(rSquared, rSquared_control)
  expect_equal(rSquared[1:2,], rSquared_control[1:2,], tolerance = 0.00001)
})
