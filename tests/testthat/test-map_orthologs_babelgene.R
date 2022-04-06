test_that("map_orthologs_babelgene works", {
    
    data("exp_mouse")

    #### mouse ==> human ####
    gene_map1 <- orthogene:::map_orthologs_babelgene(
        genes = rownames(exp_mouse),
        input_species = "mouse",
        output_species = "human"
    )
    testthat::expect_gte(nrow(gene_map1), 13000)

    #### human ==> mouse ####
    gene_map2 <- orthogene:::map_orthologs_babelgene(
        genes = gene_map1$ortholog_gene,
        input_species = "human",
        output_species = "mouse"
    )
    testthat::expect_gte(nrow(gene_map2), 13000)

    #### mouse ==> chicken ####
    testthat::expect_error(
        gene_map3 <- map_orthologs_babelgene(
            genes = rownames(exp_mouse),
            input_species = "mouse",
            output_species = "Gallus gallus"
        )
    )

    #### human ==> human ####
    gene_map3 <- orthogene:::map_orthologs_babelgene(
        genes = gene_map1$ortholog_gene,
        input_species = "human",
        output_species = "human"
    )
    testthat::expect_equal(nrow(gene_map1), nrow(gene_map3))
})
