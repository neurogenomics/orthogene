to_sparse <- function(gene_df2,
                      verbose = TRUE) {
    messager("Converting obj to sparseMatrix.", v = verbose)
    if (!is_sparse_matrix(gene_df2)) {
        if (methods::is(gene_df2, "data.frame") |
            methods::is(gene_df2, "data.table") |
            methods::is(gene_df2, "matrix") |
            methods::is(gene_df2, "Matrix")) {
            gene_df2 <- methods::as(as.matrix(gene_df2), "sparseMatrix")
        }
    }
    return(gene_df2)
}
