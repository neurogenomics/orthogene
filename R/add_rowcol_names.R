add_rowcol_names <- function(gene_df2,
                             orth_dict,
                             genes2,
                             gene_output,
                             verbose = TRUE) {
    #### Add genes as rownames ####
    if (gene_output %in% gene_output_opts(rownames_opts = TRUE)) {
        messager("Setting ortholog_gene to rownames.", v = verbose)
        rownames(gene_df2) <- orth_dict[genes2]
        gene_output <- "rownames"
    }
    #### Add genes as colnames ####
    if (tolower(gene_output) %in% gene_output_opts(colnames_opts = TRUE)) {
        messager("Setting ortholog_gene to colnames.", v = verbose)
        colnames(gene_df2) <- orth_dict[genes2]
        gene_output <- "colnames"
    }
    return(gene_df2)
}
