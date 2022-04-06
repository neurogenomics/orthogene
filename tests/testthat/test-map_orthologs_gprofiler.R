test_that("map_orthologs_gprofiler works", {
  
    data("exp_mouse")
    
    gene_map <- orthogene:::map_orthologs_gprofiler(genes=rownames(exp_mouse),
                                        input_species="mouse",
                                        output_species = "human")
    testthat::expect_gte(nrow(gene_map), 15000)
})
