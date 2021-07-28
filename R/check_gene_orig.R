check_gene_orig <- function(gene_df,
                            verbose=TRUE){
  ### Avoid confusing Biocheck
  Gene_orig <- NULL
  if("Gene_orig" %in% colnames(gene_df)){
    messager("+ Removing Gene_orig col...",v=verbose)
    gene_df <- dplyr::select(gene_df, -Gene_orig)
  }
  return(gene_df)
}