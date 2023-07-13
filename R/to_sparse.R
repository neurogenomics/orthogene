to_sparse <- function(gene_df2,
                      allow_delayed_array=TRUE,
                      verbose = TRUE) {
    
    if (!is_sparse_matrix(gene_df2)) {
        if (methods::is(gene_df2, "data.frame") |
            methods::is(gene_df2, "data.table") |
            methods::is(gene_df2, "matrix") |
            methods::is(gene_df2, "Matrix") |
            (is_delayed_array(gene_df2) && isFALSE(allow_delayed_array) )) {
            messager("Converting obj to sparseMatrix.", v = verbose) 
            gene_df2 <- methods::as(as.matrix(gene_df2), "sparseMatrix")
        }
    }
    return(gene_df2)
}
