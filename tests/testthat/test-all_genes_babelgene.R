test_that("all_genes_babelgene works", {
    
    genes <- orthogene:::all_genes_babelgene(species = "dmelanogaster")
    message(nrow(genes))
    testthat::expect_gte(nrow(genes), 19000)
    testthat::expect_gte(length(unique(genes$Gene.Symbol)), 8000)
    testthat::expect_gte(length(unique(genes$human_symbol)), 11000)
})
