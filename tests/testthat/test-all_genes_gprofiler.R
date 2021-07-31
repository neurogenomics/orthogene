test_that("all_genes_gprofiler works", {
  genes <- all_genes_gprofiler(species="dmelanogaster")
  message(nrow(genes))
  testthat::expect_gte(nrow(genes), 4000)
})
