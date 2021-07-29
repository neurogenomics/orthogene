#' Check gene_df
#' 
#' Handles gene_df regardless of whether it's a
#' data.frame, matrix, list, or vector
#' 
#' @inheritParams convert_orthologs 
#' 
#' @return List of gene_df and gene_col
#' @importFrom methods is
#' @keywords internal
check_gene_df_type <- function(gene_df,
                               gene_col,
                               verbose=TRUE){
  messager("Preparing gene_df.",v=verbose)
  if(!(is.data.frame(gene_df)) && 
     !(is(gene_df,"matrix")) && 
     !(is(gene_df,"Matrix")) ){
    # From vector/list
    if(is(gene_df,"vector") | is(gene_df,"list")){
      gene_df <- data.frame(input_gene=gene_df)
      gene_col <- "input_gene"
    }
    # From data.frame/matrix
  } 
  # else {
  #   gene_df <- data.frame(as.matrix(gene_df))
  # }
  return(list(gene_df=gene_df, 
              gene_col=gene_col))
}