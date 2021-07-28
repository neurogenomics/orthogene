test_that("convert_orthologs works", {
  data("exp_mouse")
  gene_df1 <- convert_orthologs(gene_df = exp_mouse, 
                                input_species="mouse",
                                gene_col="rownames",
                                drop_nonorths = TRUE)
  gene_df2 <- homologene::mouse2human(rownames(exp_mouse)) 
  human_genes2 <- gene_df2$humanGene[!is.na(gene_df2$humanGene)]
  mouse_genes2 <- gene_df2$mouseGene[!is.na(gene_df2$mouseGene)]
  
  n_human_genes <- sum(gene_df1$Gene %in% human_genes2)
  n_mouse_genes <- sum(gene_df1$Gene_orig %in% mouse_genes2)
  
  testthat::expect_equal(n_human_genes,nrow(gene_df1))
  testthat::expect_equal(n_mouse_genes,nrow(gene_df1))
})
