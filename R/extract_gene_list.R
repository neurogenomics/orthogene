extract_gene_list <- function(gene_df,
                              gene_input,
                              verbose = TRUE) {
    if (tolower(gene_input) %in% gene_input_opts(
        rownames_opts = TRUE)) {
        messager("Extracting genes from rownames.", v = verbose)
        genes <- rownames(gene_df)
    } else if (tolower(gene_input) %in% gene_input_opts(
        colnames_opts = TRUE)) {
        messager("Extracting genes from colnames.", v = verbose)
        genes <- colnames(gene_input)
    } else if (gene_input %in% gene_input_opts(
        gene_df = gene_df,
        columns_opts = TRUE
    )) {
        messager("Extracting genes from", 
                 paste0(gene_input, "."), v = verbose)
        if (methods::is(gene_df, "data.table")) {
            ### data.table doesn't allow gene_df[,gene_input] syntax
            genes <- gene_df[[gene_input]]
        } else {
            ### Important!:
            # (sparse) matrices don't allow gene_df[[gene_input]] syntax
            genes <- gene_df[, gene_input]
        }
    } else {
        all_opts <- gene_input_opts(
            gene_df = gene_df,
            rownames_opts = TRUE,
            colnames_opts = TRUE,
            columns_opts = TRUE,
            print_friendly = TRUE
        )
        stop_msg <- c(
            "gene_input must match one of:\n",
            all_opts
        )
        stop(stop_msg)
    }
    return(genes)
}
