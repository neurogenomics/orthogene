test_that("all_genes_gprofiler works", {
    
    genes <- orthogene:::all_genes_gprofiler(species = "dmelanogaster", 
                                             force = TRUE)
    message(nrow(genes))
    testthat::expect_gte(nrow(genes), 4000)
    
    genes <- orthogene:::all_genes_gprofiler(species = "dmelanogaster", 
                                             force = FALSE)
    message(nrow(genes))
    testthat::expect_gte(nrow(genes), 4000)
})
