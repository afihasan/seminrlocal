context("SEMinR correctly returns validity metrics in summary for class seminr_model\n")

## Setup model ----
# seminr syntax for creating measurement model
mobi_mm <- constructs(
  composite("Image",        multi_items("IMAG", 1:5),weights = mode_A),
  composite("Expectation",  multi_items("CUEX", 1:3),weights = mode_A),
  composite("Value",        multi_items("PERV", 1:2),weights = mode_A),
  composite("Satisfaction", multi_items("CUSA", 1:3),weights = mode_A)
)

# Single endogenous construct model (should still return a list of antecedents in results)
mobi_sm1 <- relationships(
  paths(to = "Satisfaction",
        from = c("Image", "Expectation", "Value"))
)

# Multiple endogenous constructs model
mobi_sm2 <- relationships(
  paths(to = "Satisfaction",
        from = c("Image", "Expectation", "Value")),
  paths(to = "Value",
        from = c("Image", "Expectation"))
)

# Load data, assemble model, and estimate using semPLS
model1 <- estimate_pls(mobi, mobi_mm, mobi_sm1, inner_weights = path_weighting)
model2 <- estimate_pls(mobi, mobi_mm, mobi_sm2, inner_weights = path_weighting)

summary1 <- summary(model1)
summary2 <- summary(model2)

flatten_vifs <- function(vif_results) {
  as.data.frame(t(unlist(vif_results)))
}

flat_vif_items1 <- flatten_vifs(summary1$validity$vif_items)
flat_vif_antecedents1 <- flatten_vifs(summary1$vif_antecedents)
flat_vif_antecedents2 <- flatten_vifs(summary2$vif_antecedents)
fl_table <- summary1$validity$fl_criteria

## Create Original Fixtures ----
# write.csv(flat_vif_items1, "tests/fixtures/vifs/flat_item_vifs1.csv", row.names = FALSE)
# write.csv(flat_vif_antecedents1, "tests/fixtures/vifs/flat_vif_antecedents1.csv", row.names = FALSE)
# write.csv(flat_vif_antecedents2, "tests/fixtures/vifs/flat_vif_antecedents2.csv", row.names = FALSE)
# write.csv(fl_table, "tests/fixtures/V_3_6_0/fl_table.csv", row.names = FALSE)
# write.csv(fl_table, "tests/fixtures/V_3_5_X/fl_table.csv", row.names = FALSE)

## Load Fixtures ----
correct_item_vifs1 <- read.csv(file = paste(test_folder,"vifs/flat_item_vifs1.csv", sep = ""), check.names = FALSE)
correct_vif_antecedents1 <- read.csv(file = paste(test_folder,"vifs/flat_vif_antecedents1.csv", sep = ""), check.names = FALSE)
correct_vif_antecedents2 <- read.csv(file = paste(test_folder,"vifs/flat_vif_antecedents2.csv", sep = ""), check.names = FALSE)
correct_fl_table <- as.matrix(read.csv(file = paste(test_folder,"fl_table.csv", sep = ""), check.names = FALSE))

## Tests ----
test_that("Seminr computes the item VIFs correctly", {
  expect_equal(unname(flat_vif_items1), unname(correct_item_vifs1), tolerance = 0.00001)
})

test_that("Seminr computes the antecedent VIFs correctly for single endogenous variable", {
  expect_equal(unname(flat_vif_antecedents1), unname(correct_vif_antecedents1), tolerance = 0.00001)
})

test_that("Seminr computes the antecedent VIFs correctly for multiple endogenous variables", {
  expect_equal(unname(flat_vif_antecedents2), unname(correct_vif_antecedents2), tolerance = 0.00001)
})

test_that("Seminr computes the Fornell Larcker criteria correctly", {
  expect_equal(unname(fl_table[1:4,1:4]), unname(correct_fl_table), tolerance = 0.00001)
})
