check_one_to_one <- function(gene_df,
                             verbose=TRUE){ 
    messager("+ Dropping genes that don't have 1:1 gene mappings...",v=verbose)
    gene_df <- gene_df[!duplicated(gene_df$Gene_orig),]
    gene_df <- gene_df[!duplicated(gene_df$Gene),] 
    return(gene_df)
}