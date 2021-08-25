check_matrix <- function(gene_df2,
                         gene_output,
                         verbose = TRUE) {
    if ((methods::is(gene_df2, "matrix") | methods::is(gene_df2, "Matrix")) &
        (!is_sparse_matrix(gene_df2)) &
        (c(gene_output == "columns"))) {
        messager("WARNING:",
            "Will convert gene_df from dense matrix to data.frame",
            "when gene_output='columns'.",
            v = verbose
        )
        gene_df2 <- data.frame(gene_df2,
            check.names = FALSE,
            stringsAsFactors = FALSE
        )
    }
    return(gene_df2)
}
