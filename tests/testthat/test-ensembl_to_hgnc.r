test_that("ensembl_to_hgnc works", {
  ensembl_IDs <- c("ENSG00000128573","ENSG00000176697","ENSG00000077279","ENSG00000131095" )
  gene_symbols <- ensembl_to_hgnc(ensembl_IDs)
  testthat::expect_equal(length(gene_symbols),length(ensembl_IDs))
})
