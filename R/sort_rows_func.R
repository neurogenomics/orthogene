sort_rows_func <- function(gene_df,
                           verbose=TRUE){
  messager("Sorting rownames alphanumerically.",v=verbose)
  gene_df <- gene_df[sort(rownames(gene_df)),]
  return(gene_df)
}