add_columns <- function(gene_df2,
                        input_dict,
                        orth_dict,
                        genes2,
                        gene_map,
                        standardise_genes,
                        verbose = TRUE) {

    #### Add ortholog_gene col ####
    messager("Adding input_gene col to gene_df.", v = verbose)
    gene_df2$input_gene <- input_dict[genes2]
    #### Add input_gene_standard col ####
    if (standardise_genes) {
        messager("Adding input_gene_standard col to gene_df.", v = verbose)
        std_dict <- stats::setNames(
            gene_map$input_gene_standard,
            gene_map$input_gene
        )
        gene_df2$input_gene_standard <- std_dict[genes2]
    }
    #### Add ortholog_gene col ####
    messager("Adding ortholog_gene col to gene_df.", v = verbose)
    gene_df2$ortholog_gene <- orth_dict[genes2]
    return(gene_df2)
}
