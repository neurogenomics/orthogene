test_that("aggregate_mapped_genes works", {
  
  #### Aggregate: orthologs ####
  data("exp_mouse")
  gene_map <- map_orthologs(genes = rownames(exp_mouse),
                            input_species = "mouse")
  agg_exp <- aggregate_mapped_genes(gene_df = exp_mouse,
                                    species = "mouse",
                                    FUN = "sum", 
                                    gene_map = gene_map,
                                    gene_map_col = "ortholog_gene")
  testthat::expect_lte(nrow(agg_exp), nrow(exp_mouse))
  testthat::expect_equal(is_sparse_matrix(agg_exp), TRUE)
  testthat::expect_equal(ncol(agg_exp), ncol(exp_mouse))
  
  #### Aggregate: transcripts ####
  data("exp_mouse_enst")
  agg_enst <- aggregate_mapped_genes(gene_df=exp_mouse_enst,
                                     species="mouse",
                                     FUN = "sum")
  testthat::expect_lte(nrow(agg_enst), nrow(exp_mouse_enst))
  testthat::expect_equal(is_sparse_matrix(agg_enst), TRUE)
  testthat::expect_equal(ncol(agg_enst), ncol(exp_mouse_enst))
})
