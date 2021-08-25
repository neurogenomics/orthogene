aggregate_mapped_genes_twice <- function(gene_df2,
                                         non121_strategy,
                                         gene_map,
                                         verbose = TRUE) {
    gene_df2 <- aggregate_mapped_genes(
        gene_df = gene_df2,
        FUN = non121_strategy,
        gene_map = gene_map,
        gene_map_col = "input_gene",
        verbose = verbose
    )
    gene_df2 <- aggregate_mapped_genes(
        gene_df = gene_df2,
        FUN = non121_strategy,
        gene_map = gene_map,
        gene_map_col = "ortholog_gene",
        verbose = verbose
    )
    return(gene_df2)
}
