test_that("ortholog_report works", {
  orth.fly <- ortholog_report(target_species = "fly",
                              reference_species="human")
  orth.zeb <- ortholog_report(target_species = "zebrafish",
                              reference_species="human")
  orth.mus <- ortholog_report(target_species = "mouse",
                              reference_species="human")
  testthat::expect_equal(nrow(orth.fly$map)>4000, TRUE)
  testthat::expect_equal(nrow(orth.zeb$map)>1100, TRUE)
  testthat::expect_equal(nrow(orth.zeb$map)>1500, TRUE)
})
