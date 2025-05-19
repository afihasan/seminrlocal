# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project largely adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.3.1] - 2022-06-30

### [2.3.1] Changes

- Reports correct item correlations for cbsem summary
- records rawdata (which is kept unchanged) in estimate_cbsem()
- takes intersection of rawdata and item_names in summarize_cb_measurement()
- Loadings and reliabilities for HOCs in CBSEM
- Single HOF in CBSEM has reported loadings and reliabilities
- Tests ensuring loadings, reliabilities for multiple HOFs in CBSEM model
- Add constructs, loadings to CFA object and reliablities to CFA summary
- Refactor HOF/HOC --> HOC in code
- refactor and comments

- fixed bug arising from plotting two-stage models
- added warnings for attempting to run plspredict on models with HOC or moderations
- Added RhoC for reflective composites
- Added unit weighting function unit_weights() 
- resolved issues with matrix coercion to vector
- resolved issues arising from changes to lavaan

## [2.3.0] - 2022-01-04

### [2.3.0] Added

- Added a new feature PLS MGA

## [2.2.1] - 2021-09-01

### [2.2.1] Changed

- Modified the bootstrap function so that it excludes iterations in which the PLSc model fails to converge.
- Corrected a bug that displayed the incorrect threshold on the reliability plot.=

## [2.2.0] - 2021-08-18

### [2.2.0] Changed

- Updated the summary() function to apply fSquares() to interaction models
- Updated fSquares() function to not calculate fSquare for antecedents involved in interactions
- Fixed a bug in the plotting of formative constructs in PLS

### [2.2.0] Added

- Citation to SSRN paper

## [2.0.1] - 2021-03-21

### [2.0.1] Changed

- Updated the namespace to exclude MASS
- Removed the simulation of a fixture in the test-plsc-fsquared file

## [2.0.0] - 2021-02-21

### [2.0.0] Added

- S3 plot() method for visualizing all SEMinR models - CFA, CBSEM, PLS, PLSc

## [1.2.0] - 2020-12-31

### [1.2.0] Added

- A new feature to plot interaction plots
- Demo files for PLS Primer in R Workbook
- PLSpredict feature
- total paths and indirect effects
- New visualization for reliability
- Cronbachs alpha to reliability
- new datasets = corp_rep_data2 and corp_rep_data
- new method for calculating AIC and BIC
- new demonstration files for an accompanying textbook

### [1.2.0] Changed

- Changed output of summary() to generate standardized matrices and lists with an S3 print method
- Changed HOC to combine first and second stage results for outer loadings and outer weights
- Changed estimate_bootstrap() to process bootstrap matrix in a way that is naive to differences in matrix layouts

###[1.2.0] Removed
- old test fixtures for V 3.5.X (deprecated by R)

## [1.1.0] - 2020-07-01

### [1.1.0] Added

- A new feature to process reflective CFA/CBSEM models through Lavaan
  - Measurement/structural models converted into Lavaan syntax
  - New item error covariances specification created for CFA/CBSEM measurement
  - By default, MLR (robust ML) estimation used
  - User can pass parameters to Lavaan's estimate_* functions (e.g., fiml)
  - `summary()` of CFA/CBSEM estimation uses information from Lavaan summaries
- A new feature to extract ten Berge scores for CFA/CBSEM models
- Tests added for new features
- Demos added to show new features

### [1.1.0] Changed

- Updated several features to work for both PLS and CFA/CBSEM
  - Interactions work for PLS and CBSEM
  - Two_stage adapts to CBSEM, using CFA to get ten Berge scores in first stage
  - R^2 and VIFs computed using correlation matrices instead of `lm()`
- Updated summary objects to hold meta information of estimation method
- Vignette updated to show new features

## [1.0.2] - 2020-04-28

- Fixed q bug in fSquares method for single path structural models.

## [1.0.1] - 2019-12-11

### [1.0.1] Changed

- Patched if() conditionals including class() to reflect new CRAN class of matrix as c("matrix", "array") in R V4.0.0
- Change code syntax to remove interactions() method and add interactions and HOC to composites()
- Document all the syntax and features

## [1.0.1] - 2019-12-11
### Changed
- Patched if() conditionals including class() to reflect new CRAN class of matrix as c("matrix","array") in R V4.0.0

## [0.1.0] - 2019-09-27

### [0.1.0] Added

- A changelog
- A new feature for automated calculation of HOC
- A new feature for two-stage calculation of interactions
- A file for all references and citations
- A return object in summary(boot_seminr_model) containing boot mean, SD, tvalue, and CIs for bootstrapped paths, loadings, weights and HTMT, 
- A test for the bootstrap summary return object
- Descriptive statistics for item and construct data
- S3 print method for class "table_output" for printing generic tables
- new method interaction_term() for specifying a interaction construct
- A fSquare function to calculating fSquared
- A test for fSquared function

### [0.1.0] Changed

- Fixtures for evaluating bootstrap HTMT for versions of R < 3.6.0
- Changed the R/* file naming to R/estimate_ R/feature_ R/evaluate_ etc.
- Summary S3 method to return data descriptives in summary object
- constructs() method now returns a list with classes
- Changed references to include Cohen (2013)
- Updated vignette to reflect fSquare function

### [0.1.0] Fixed

- Modified calculation of HTMT to use absolute correlation matrices in order to make HTMT stable
