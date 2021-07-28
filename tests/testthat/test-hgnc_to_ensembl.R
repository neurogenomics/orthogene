test_that("hgnc_to_ensembl works", {
  gene_symbols <- c("FOXP2","BDNF","DCX","GFAP")
  ensembl_IDs <- hgnc_to_ensembl(gene_symbols)
  testthat::expect_equal(length(gene_symbols), length(ensembl_IDs))
})
