gene_output_opts <- function(rownames_opts = FALSE,
                             colnames_opts = FALSE,
                             columns_opts = FALSE,
                             dict_opts = FALSE) {
    opts <- c()
    if (rownames_opts) {
        opts <- c(opts, c("rownames", "row.names", "row_names", 0))
    }
    if (colnames_opts) {
        opts <- c(opts, c("colnames", "col.names", "col_names", 1))
    }
    if (columns_opts) {
        opts <- c(opts, c("columns", "column", "cols", "col"))
    }
    if (dict_opts) {
        opts <- c(opts, c("dict", "dict_rev"))
    }
    return(opts)
}
