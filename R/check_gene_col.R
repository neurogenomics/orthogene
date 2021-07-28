check_gene_col <- function(gene_df,
                           gene_col,
                           verbose=TRUE){
  if(tolower(gene_col) %in% c("rownames","row.names","row_names")){
    messager("+ Converting rownames to Gene col...",v=verbose)
    gene_df$Gene <- rownames(gene_df)
    gene_col <- "Gene"
  }else {
    gene_df$Gene <- gene_df[[gene_col]]
  }
  return(gene_df)
}