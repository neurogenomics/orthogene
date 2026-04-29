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

    #### transpose = TRUE branch ####
    ## Transpose flips the input so genes are columns; aggregate_mapped_genes
    ## should still work because it transposes back internally before reading
    ## rownames as genes.
    exp_t <- Matrix::t(exp_mouse)
    agg_t <- orthogene::aggregate_mapped_genes(
        gene_df = exp_t,
        gene_map = gene_map,
        agg_fun = "sum",
        transpose = TRUE
    )
    testthat::expect_true(orthogene:::is_sparse_matrix(agg_t))
    testthat::expect_lte(nrow(agg_t), ncol(exp_t))

    #### Within-species path: input_species == output_species ####
    ## Triggers the map_genes() branch (line 113-130 of aggregate_mapped_genes)
    ## that standardises symbols rather than calling map_orthologs.
    agg_within <- orthogene::aggregate_mapped_genes(
        gene_df = exp_mouse,
        input_species = "mouse",
        output_species = "mouse",
        agg_fun = "sum"
    )
    testthat::expect_true(orthogene:::is_sparse_matrix(agg_within))
    testthat::expect_lte(nrow(agg_within), nrow(exp_mouse))

    #### sort_rows = TRUE ####
    agg_sorted <- orthogene::aggregate_mapped_genes(
        gene_df = exp_mouse,
        gene_map = gene_map,
        agg_fun = "sum",
        sort_rows = TRUE
    )
    testthat::expect_true(orthogene:::is_sparse_matrix(agg_sorted))
    rn <- rownames(agg_sorted)
    testthat::expect_identical(rn, sort(rn))

    #### as_integers = TRUE ####
    agg_int <- orthogene::aggregate_mapped_genes(
        gene_df = exp_mouse,
        gene_map = gene_map,
        agg_fun = "sum",
        as_integers = TRUE
    )
    testthat::expect_true(orthogene:::is_sparse_matrix(agg_int))

    #### Early-exit path: 1:1 input → output rename, no aggregation needed ####
    ## A gene_map with the same number of unique input/output names hits the
    ## "nothing to aggregate, just rename" branch (lines 139-149).
    n_keep <- 5
    sub_genes <- rownames(exp_mouse)[seq_len(n_keep)]
    map_11 <- data.frame(
        input_gene = sub_genes,
        ortholog_gene = paste0(sub_genes, "_renamed")
    )
    sub_mat <- exp_mouse[sub_genes, , drop = FALSE]
    agg_rename <- orthogene::aggregate_mapped_genes(
        gene_df = sub_mat,
        gene_map = map_11,
        agg_fun = "sum"
    )
    testthat::expect_equal(nrow(agg_rename), n_keep)
    testthat::expect_true(all(grepl("_renamed$", rownames(agg_rename))))
})
