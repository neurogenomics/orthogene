gene_input_opts <- function(gene_df = NULL,
                            rownames_opts = FALSE,
                            colnames_opts = FALSE,
                            columns_opts = FALSE,
                            print_friendly = FALSE) {
    opts <- c()
    if (rownames_opts) {
        rown_opts <- c("rownames", "row.names", "row_names", 0)
        opts <- c(opts, rown_opts)
    }
    if (colnames_opts) {
        coln_opts <- c("colnames", "col.names", "col_names", 1)
        opts <- c(opts, coln_opts)
    }
    if (columns_opts && (!is.null(gene_df))) {
        colu_opts <- colnames(gene_df)
        if (print_friendly == FALSE) {
            opts <- c(opts, colu_opts)
        } else {
            colu_opts <- c(colu_opts[seq(1, 3)], "...")
            opts <- c(
                paste("  - ROW NAMES:", 
                      paste(rown_opts, collapse = " / "), "\n"),
                paste("  - COLUMN NAMES:", 
                      paste(coln_opts, collapse = " / "), "\n"),
                paste("  - COLUMNS:", 
                      paste(colu_opts, collapse = " / "), "\n")
            )
        }
    }
    return(opts)
}
