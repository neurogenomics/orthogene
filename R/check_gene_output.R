check_gene_output <- function(gene_output) {
    all_opts <- gene_output_opts(
        rownames_opts = TRUE,
        colnames_opts = TRUE,
        columns_opts = TRUE,
        dict_opts = TRUE
    )
    if (!(tolower(as.character(gene_output)) %in% all_opts)) {
        stop_msg <- c("gene_output must be one of:\n", 
                      paste0("  - ", all_opts, "\n"))
        stop(stop_msg)
    }
}
