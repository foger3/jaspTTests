context("Paired Samples TTest")

# does not test
# - missing values exclusion
# - error handling of plots

test_that("Main table results match for one pair * multiple tests", {
  options <- jaspTools::analysisOptions("TTestPairedSamples")
  options$pairs <- list(c("contNormal", "contGamma"))
  options$wilcoxonSignedRank <- TRUE
  options$hypothesis <- "groupOneGreater"
  options$meanDifference <- TRUE
  options$effectSize <- TRUE
  options$effSizeConfidenceIntervalCheckbox <- TRUE
  options$VovkSellkeMPR <- TRUE
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  table <- results[["results"]][["ttest"]][["data"]]
  jaspTools::expect_equal_tables(table,
     list("TRUE", -11.6121720596087, 1, -1.16121720596087, 99, -1.37211873031366,
          -2.22170938375, 1, 0.191325909773409, "-", "Student", "<unicode>",
          "contNormal", "contGamma", "FALSE", 199, 1, -0.921188118811881,
          "", -0.94536640190499, -2.1796113893332, 0.999999999999999,
          "", "", "Wilcoxon", "<unicode>", "", "", -7.99754358622852
     )
  )
})

test_that("Main table results match for multiple pairs * one test", {
  options <- jaspTools::analysisOptions("TTestPairedSamples")
  options$pairs <- list(c("contNormal", "contGamma"), c("contNormal", "contcor1"))
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  table <- results[["results"]][["ttest"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("FALSE", 99, 3.4809614504484e-20, "-", -11.6121720596087, "contNormal",
	                         "contGamma", "FALSE", 99, 0.0750733655901379, "-", -1.79895113042557,
	                         "contNormal", "contcor1")
  )
})

test_that("Normality table matches", {
  options <- jaspTools::analysisOptions("TTestPairedSamples")
  options$pairs <- list(c("contNormal", "contGamma"))
  options$normalityTests <- TRUE
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  table <- results[["results"]][["AssumptionChecks"]][["collection"]][["AssumptionChecks_ttestNormalTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(0.969542808533914, 0.0203952735337306, "-", "contNormal", "contGamma")
  )
})

test_that("Descriptives table matches", {
  options <- jaspTools::analysisOptions("TTestPairedSamples")
  options$pairs <- list(c("contNormal", "contGamma"))
  options$descriptives <- TRUE
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  table <- results[["results"]][["ttestDescriptives"]][["collection"]][["ttestDescriptives_table"]][["data"]]
  jaspTools::expect_equal_tables(table,
      list(100, -5.60753128268502, -0.18874858754, 1.05841360919316, 0.105841360919316,
           "contNormal", 100, 0.753782920490781, 2.03296079621, 1.53241112621044,
           0.153241112621044, "contGamma"))
})

test_that("Descriptives plot matches", {
  options <- jaspTools::analysisOptions("TTestPairedSamples")
  options$pairs <- list(c("contNormal", "contGamma"))
  options$descriptivesPlots <- TRUE
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "descriptives")
})

test_that("Bar plot matches", {
  options <- jaspTools::analysisOptions("TTestPairedSamples")
  options$pairs <- list(c("contNormal", "contGamma"))
  options$descriptivesPlotsTwo <- TRUE
  options$errorBarType <- "standardError"
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "barPlot")
})

test_that("Raincloud plot matches", {
  options <- jaspTools::analysisOptions("TTestPairedSamples")
  options$pairs <- list(c("contNormal", "contGamma"))
  options$descriptivesPlotsRainCloud <- TRUE
  set.seed(12312414)
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "raincloud")
})

test_that("Raincloud difference plot matches (vertical)", {
  options <- jaspTools::analysisOptions("TTestPairedSamples")
  options$pairs <- list(c("contNormal", "contGamma"))
  options$descriptivesPlotsRainCloudDifference <- TRUE
  set.seed(12312414)
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "raincloud-diff-vertical")
})

test_that("Raincloud difference plot matches (horizontal)", {
  options <- jaspTools::analysisOptions("TTestPairedSamples")
  options$pairs <- list(c("contNormal", "contGamma"))
  options$descriptivesPlotsRainCloudDifference <- TRUE
  options$descriptivesPlotsRainCloudDifferenceHorizontalDisplay <- TRUE
  set.seed(12312414)
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "raincloud-diff-horizontal")
})

test_that("Analysis handles errors", {
  options <- jaspTools::analysisOptions("TTestPairedSamples")

  options$pairs <- list(c("contNormal", "debInf"))
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  notes <- unlist(results[["results"]][["ttest"]][["footnotes"]])
  expect_true(any(grepl("infinity", notes, ignore.case=TRUE)), label = "Inf check")

  options$pairs <- list(c("contNormal", "debSame"))
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  notes <- unlist(results[["results"]][["ttest"]][["footnotes"]])
  expect_true(any(grepl("variance", notes, ignore.case=TRUE)), label = "No variance check")

  options$pairs <- list(c("contNormal", "debMiss99"))
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  notes <- unlist(results[["results"]][["ttest"]][["footnotes"]])
  expect_true(any(grepl("observations", notes, ignore.case=TRUE)), label = "Too few obs check")

  options <- jaspTools::analysisOptions("TTestPairedSamples")
  options$pairs <- list(c("contNormal", "contNormal"))
  results <- jaspTools::runAnalysis("TTestPairedSamples", "test.csv", options)
  status <- results[["status"]]
  expect_identical(status, "validationError")
})
