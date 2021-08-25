filter_gene_df <- function(gene_input,
                           gene_df,
                           genes,
                           gene_map,
                           verbose = TRUE) {
    messager("Filtering gene_df with gene_map", v = verbose)
    #### Subset by columns ####
    if (tolower(gene_input) %in% gene_input_opts(colnames_opts = TRUE)) {
        gene_df2 <- gene_df[, genes %in% gene_map$input_gene]
    } else if (tolower(gene_input) %in% gene_input_opts(rownames_opts = TRUE) |
        gene_input %in% gene_input_opts(
            gene_df = gene_df,
            columns_opts = TRUE
        )) {
        gene_df2 <- gene_df[genes %in% gene_map$input_gene, ]
    } else {
        stop_msg <- paste0(
            "gene_input='", gene_input,
            "' not recognised as an option."
        )
        stop(stop_msg)
    }
    #### Subset original genes to those available in gene_map ####
    genes2 <- genes[genes %in% gene_map$input_gene]
    return(list(
        gene_df2 = gene_df2,
        genes2 = genes2
    ))
}
