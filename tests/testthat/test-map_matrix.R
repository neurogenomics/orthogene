test_that("map_matrix works", {
  data("exp_mouse")
  exp_human <- map_matrix(obj=exp_mouse, input_species="mouse") 
  gene_df2 <- homologene::mouse2human(rownames(exp_mouse))
  human_genes <- sum(rownames(exp_human) %in% gene_df2$humanGene)
  testthat::expect_equal(human_genes, nrow(exp_human))
})
