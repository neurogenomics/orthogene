is_converted <- function(gene_df,
                         verbose=TRUE){
  if(all(c("input_gene","ortholog_gene") %in% colnames(gene_df))){
    messager("+ orthologs previously converted.",v=verbose)
   return(TRUE)
  } else return(FALSE)
}