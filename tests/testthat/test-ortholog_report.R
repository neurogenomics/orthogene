test_that("report_orthologs works", {
  orth.fly <- report_orthologs(target_species = "fly",
                              reference_species="human")
  orth.zeb <- report_orthologs(target_species = "zebrafish",
                              reference_species="human")
  orth.mus <- report_orthologs(target_species = "mouse",
                              reference_species="human")
  testthat::expect_equal(nrow(orth.fly$map)>4000, TRUE)
  testthat::expect_equal(nrow(orth.zeb$map)>1100, TRUE)
  testthat::expect_equal(nrow(orth.zeb$map)>1500, TRUE)
})
