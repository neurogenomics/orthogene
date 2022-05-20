test_that("aggregate_mapped_genes works", {

    #### Aggregate: orthologs ####
    data("exp_mouse")
    
    # It's not normally necessary to create gene_map outside of 
    # aggregate_mapped_genes, but this step takes a while
    # so good to use more than once.
    gene_map <- map_orthologs(
        genes = rownames(exp_mouse),
        input_species = "mouse", 
        method = "homologene"
    )
    agg_exp <- orthogene::aggregate_mapped_genes(
        gene_df = exp_mouse, 
        gene_map = gene_map,
        agg_fun = "sum"
    )
    testthat::expect_lte(nrow(agg_exp), nrow(exp_mouse))
    testthat::expect_true(orthogene:::is_sparse_matrix(agg_exp))
    testthat::expect_equal(ncol(agg_exp), ncol(exp_mouse))

    #### Aggregate: transcripts ####
    data("exp_mouse_enst")
    agg_enst <- aggregate_mapped_genes(
        gene_df = exp_mouse_enst,
        input_species = "mouse",
        agg_fun = "sum"
    )
    testthat::expect_lte(nrow(agg_enst), nrow(exp_mouse_enst))
    testthat::expect_true(orthogene:::is_sparse_matrix(agg_enst))
    testthat::expect_equal(ncol(agg_enst), ncol(exp_mouse_enst))
    
    
    #### Aggregate DelayedArray ####
    exp_da <- orthogene:::as_delayed_array(exp_mouse)
    agg_exp <- aggregate_mapped_genes(
        gene_df = exp_da,
        input_species = "mouse",
        agg_fun = "sum" ,
        gene_map = gene_map
    )
    testthat::expect_lte(nrow(agg_exp), nrow(exp_da))
    testthat::expect_true(orthogene:::is_sparse_matrix(agg_exp)) 
    testthat::expect_equal(ncol(agg_exp), ncol(exp_da))
    
    
    #### Aggregate: method="stats": without supplied gene_map ####
    exp_da <- orthogene:::as_delayed_array(exp_mouse) 
    agg_exp <- orthogene::aggregate_mapped_genes(
        gene_df = exp_da, 
        input_species = "mouse",
        output_species = "human",
        agg_fun = "sum",
        agg_method = "stats",
    )
    testthat::expect_lte(nrow(agg_exp), nrow(exp_da))
    testthat::expect_true(orthogene:::is_sparse_matrix(agg_exp)) 
    testthat::expect_equal(ncol(agg_exp), ncol(exp_da))
})
