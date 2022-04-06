test_that("map_orthologs works", {
  
    data("exp_mouse")
    gene_map <- orthogene::map_orthologs(
        genes = rownames(exp_mouse),
        input_species = "mouse"
    )
})
