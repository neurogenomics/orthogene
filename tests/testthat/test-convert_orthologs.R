test_that("convert_orthologs works", {
  
  data("exp_mouse") 
  #### Prepare different formats ####
  exp_mouse_smat <- exp_mouse
  exp_mouse_dmat <- as.matrix(exp_mouse)
  exp_mouse_df <- data.frame(as.matrix(exp_mouse), 
                             check.rows = FALSE)
  #### Define check function ####
  has_gene_cols <- function(dat){
    sum(c("input_gene","ortholog_gene") %in% colnames(dat))
  }
  ##### Run conversions ####
  # sparse matrix ==> sparse matrix: as rownames
  gene_smat1 <- convert_orthologs(gene_df = exp_mouse_smat, 
                                 input_species="mouse",
                                 gene_input="rownames",
                                 gene_output = "rownames")
  testthat::expect_equal(methods::is(gene_smat1,"sparseMatrix"), TRUE)
  testthat::expect_equal(has_gene_cols(gene_smat1),0)
  # dense matrix ==> dense matrix: as rownames
  gene_dmat1 <- convert_orthologs(gene_df = exp_mouse_dmat, 
                                  input_species="mouse",
                                  gene_input="rownames",
                                  gene_output = "rownames")
  testthat::expect_equal(methods::is(gene_dmat1,"matrix"), TRUE)
  testthat::expect_equal(has_gene_cols(gene_dmat1),0)
  # dense matrix ==> data.frame: as columns
  gene_dmatc1 <- convert_orthologs(gene_df = exp_mouse_dmat, 
                                   input_species="mouse",
                                   gene_input="rownames",
                                   gene_output = "columns")
  testthat::expect_equal(methods::is(gene_dmatc1,"data.frame"), TRUE)
  testthat::expect_equal(has_gene_cols(gene_dmatc1),2)
  # data.frame ==> data.frame: as columns
  gene_df1 <- convert_orthologs(gene_df = exp_mouse_df, 
                                input_species="mouse",
                                gene_input="rownames",
                                gene_output = "columns")
  testthat::expect_equal(methods::is(gene_df1,"data.frame"), TRUE)
  testthat::expect_equal(has_gene_cols(gene_df1),2) 
  
  # data.frame ==> data.frame: as typo
  testthat::expect_error(
    gene_dfTYPO1 <- convert_orthologs(gene_df = exp_mouse_df, 
                                      input_species="mouse",
                                      gene_input="rownamesTYPO",
                                      gene_output = "columns")
  )
})
