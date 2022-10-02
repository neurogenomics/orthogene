test_that("map_orthologs_babelgene works", {
    
    data("exp_mouse")
    
    ## ====== babelgene ====== ##
    
    gene_map_b1 <- babelgene::orthologs( 
        genes = rownames(exp_mouse),
        species = "mouse",
        human = FALSE
    )  
    testthat::expect_gte(nrow(gene_map_b1), 13000)
    
    gene_map_b2 <- babelgene::orthologs( 
        genes = rownames(exp_mouse),
        species = "mouse",
        human = FALSE, 
        min_support = 1
    )
    testthat::expect_gte(nrow(gene_map_b2), 13000)
    
    gene_map_b3 <- babelgene::orthologs( 
        genes = rownames(exp_mouse),
        species = "mouse",
        human = FALSE, 
        min_support = 0, 
        top = FALSE
    )  
    testthat::expect_gte(nrow(gene_map_b3), 15500)
    
    
    
    ## ====== orthogene ====== ##
    
    #### mouse ==> human ####
    gene_map1 <- orthogene:::map_orthologs_babelgene(
        genes = rownames(exp_mouse),
        input_species = "mouse",
        output_species = "human"
    )
    # Used to be 30000 in old version of babelgene
    testthat::expect_gte(nrow(gene_map1), 29500) 
    testthat::expect_true(
        all(
            head(gene_map1$ortholog_gene)==toupper(head(gene_map1$ortholog_gene))
        )
    )
    testthat::expect_false(
        all(
            head(gene_map1$input_gene)==toupper(head(gene_map1$input_gene))
        )
    )
    
    #### human ==> mouse ####
    gene_map2 <- orthogene:::map_orthologs_babelgene(
        genes = gene_map1$ortholog_gene,
        input_species = "human",
        output_species = "mouse"
    )
    testthat::expect_gte(nrow(gene_map2), 29500)
    testthat::expect_false(
        all(
            head(gene_map2$ortholog_gene)==toupper(head(gene_map2$ortholog_gene))
        )
    )
    testthat::expect_true(
        all(
            head(gene_map2$input_gene)==toupper(head(gene_map2$input_gene))
        )
    )
    
    
    #### zebrafish ==> human ####
    zgenes <- orthogene::all_genes(method = "babelgene",species = "zebrafish")
    gene_map2 <- orthogene:::map_orthologs_babelgene(
        genes = zgenes$Gene.Symbol,
        input_species = "zebrafish",
        output_species = "human"
    )
    testthat::expect_gte(nrow(gene_map2), 29500)
    
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
