extract_gene_list <- function(gene_df, 
                              gene_col,
                              verbose=TRUE){ 
  if(tolower(gene_col) %in% c("rownames","row.names","row_names")){ 
    messager("Extracting genes from rownames.",v=verbose)
    genes <- rownames(gene_df) 
  } else if (tolower(gene_col) %in% c("colnames","col.names","col_names")){ 
    messager("Extracting genes from colnames.",v=verbose)
    genes <- colnames(gene_col)
  } else { 
    messager("Extracting genes from",paste0(gene_col,"."),v=verbose)
    if(methods::is(gene_df,"data.table")){
      ### data.table doesn't allow gene_df[,gene_col] syntax 
      genes <- gene_df[[gene_col]]
    } else {
      ### Important!: 
      # (sparse) matrices don't allow gene_df[[gene_col]] syntax 
      genes <- gene_df[,gene_col] 
    }  
  }
  return(genes)
}
