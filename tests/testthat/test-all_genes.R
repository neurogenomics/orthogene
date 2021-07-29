test_that("all_genes works", {
  genome_human <- all_genes(species="human")
  genome_mouse <- all_genes(species="mouse")
  genome_zebrafish <- all_genes(species="zebrafish")
  genome_fly <- all_genes(species="fly")
  
  testthat::expect_gte(nrow(genome_human),19000)
  testthat::expect_gte(nrow(genome_mouse),21000)
  testthat::expect_gte(nrow(genome_zebrafish),20000)
  testthat::expect_gte(nrow(genome_fly),8000)
})
