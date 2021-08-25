check_sparseMatrix <- function(gene_df2,
                               gene_input,
                               gene_output,
                               verbose = TRUE) {
    if ((is_sparse_matrix(gene_df2)) &
        (c(gene_output == "columns"))) {
        messager("WARNING:",
            "Must set gene_output to 'rownames',
             'colnames','dict' or 'dict_rev'",
            "when gene_df is a sparseMatrix.",
            "Setting gene_output to", paste0("'", gene_input, "'."),
            v = verbose
        )
        gene_output <- gene_input
    }
    return(gene_output)
}
