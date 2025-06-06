context("SEMinR correctly estimates PLSc for a simple model with interaction\n")

# Test cases
## Simple case
# Creating our measurement model
mobi_mm <- constructs(
  reflective("Image",        multi_items("IMAG", 1:5)),
  reflective("Expectation",  single_item("CUEX3")),
  reflective("Value",        multi_items("PERV", 1:2)),
  reflective("Satisfaction", multi_items("CUSA", 1:3)),
  interaction_term(iv = "Image", moderator = "Expectation", method = orthogonal, weights = mode_A)
)

# Structural model
#  note: interactions should be the names of its main constructs joined by a '*' in between.
mobi_sm <- relationships(
  paths(to = "Satisfaction",
        from = c("Image", "Expectation", "Value",
                 "Image*Expectation")
  )
)

# Load data, assemble model, and estimate
mobi_pls <- estimate_pls(data = mobi,
                         measurement_model = mobi_mm,
                         structural_model = mobi_sm)
# Load outputs
sum <- summary(mobi_pls)

## Output originally created using following lines
# write.csv(sum$paths, file = "tests/fixtures/V_3_5_X/plsc-interaction-paths.csv")
# write.csv(sum$paths, file = "tests/fixtures/V_3_6_0/plsc-interaction-paths.csv")
# write.csv(sum$reliability, file = "tests/fixtures/V_3_6_0/plsc-interaction-reliability.csv")
# write.csv(sum$reliability, file = "tests/fixtures/V_3_5_X/plsc-interaction-reliability.csv")

# Load controls
paths_control <- as.matrix(read.csv(file = paste(test_folder,"plsc-interaction-paths.csv", sep = ""), row.names = 1))
reliability_control <- as.matrix(read.csv(file = paste(test_folder,"plsc-interaction-reliability.csv", sep = ""), row.names = 1))

# Testing

test_that("Seminr estimates paths and R2 correctly\n", {
  expect_equal(round(sum$paths[1:6,1],3), paths_control[1:6,1], tolerance = 0.00001)
})

test_that("Seminr estimates rhoA, AVE, rhoC (reliability) correctly\n", {
  expect_equal(as.numeric(sum$reliability), as.numeric(reliability_control), tolerance = 0.00001)
})

