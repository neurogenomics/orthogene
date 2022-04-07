test_that("map_orthologs_babelgene works", {
    
    data("exp_mouse")
    
    gene_map_b1 <- babelgene::orthologs( 
        genes = rownames(exp_mouse),
        species = "mouse",
        human = FALSE
    )  
    testthat::expect_gte(nrow(gene_map_b1), 13100)
    
    gene_map_b2 <- babelgene::orthologs( 
        genes = rownames(exp_mouse),
        species = "mouse",
        human = FALSE, 
        min_support = 1
    )
    testthat::expect_gte(nrow(gene_map_b2), 13300)
    
    gene_map_b3 <- babelgene::orthologs( 
        genes = rownames(exp_mouse),
        species = "mouse",
        human = FALSE, 
        min_support = 0, 
        top = FALSE
    )  
    testthat::expect_gte(nrow(gene_map_b3), 15900)

    #### mouse ==> human ####
    gene_map1 <- orthogene:::map_orthologs_babelgene(
        genes = rownames(exp_mouse),
        input_species = "mouse",
        output_species = "human"
    )
    testthat::expect_gte(nrow(gene_map1), 30000)

    #### human ==> mouse ####
    gene_map2 <- orthogene:::map_orthologs_babelgene(
        genes = gene_map1$ortholog_gene,
        input_species = "human",
        output_species = "mouse"
    )
    testthat::expect_gte(nrow(gene_map2), 29000)
    
    
    #### zebrafish ==> human ####
    zgenes <- orthogene::all_genes(method = "babelgene",species = "zebrafish")
    gene_map2 <- orthogene:::map_orthologs_babelgene(
        genes = zgenes$Gene.Symbol,
        input_species = "zebrafish",
        output_species = "human"
    )
    testthat::expect_gte(nrow(gene_map2), 30000)

    #### mouse ==> chicken ####
    testthat::expect_error(
        gene_map3 <- orthogene:::map_orthologs_babelgene(
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
