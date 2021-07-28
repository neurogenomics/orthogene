#' Map genes from one species to another
#'
#' Currently supports 20+ species.
#' See \code{taxa_id_dict()} for a full list of available species.
#' 
#' @param gene_df Data.frame containing the genes symbols of the input species.
#' @param gene_col Character string indicating either the 
#' input species' gene symbols are in a column with the 
#' input species gene symbols (\code{gene_col="<gene_col_name>"}) 
#' or are the row names (\code{gene_col="rownames"}).
#' @param input_species Name of the input species (e.g., "mouse","fly"). 
#' See \code{taxa_id_dict()} for a full list of available species.
#' @param output_species Name of the output species (e.g. "human").
#' @param drop_nonorths Drop genes that don't have an ortholog 
#'  in the \code{output_species}. 
#' @param one_to_one_only Drop genes that don't have a 1:1 mapping 
#' between input species and human 
#' (i.e. drop genes with multiple human orthologs).
#' @param genes_as_rownames Whether to return the data.frame 
#' with the row names set to the human orthologs.
#' @param return_dict Return a dictionary (named list) of gene mappings, 
#' where \code{names} are the original gene names and 
#'  items are the new gene names. If \code{return_dict=FALSE}, 
#'  instead returns mappings as a data.frame. 
#' @param invert_dict If \code{return_dict=TRUE}, setting \code{invert_dict} 
#' switches the names and items in the dictionary.
#' @param verbose Print messages.
#' 
#' @return Data.frame with the gene symbols of the input species ("Gene_orig") 
#' and converted human orthologs ("Gene").
#' @export
#' @import homologene
#' @importFrom dplyr select rename all_of 
#' @importFrom stats setNames 
#' @examples 
#' data("exp_mouse")
#' gene_df <- convert_orthologs(gene_df = exp_mouse, input_species="mouse",
#'                              gene_col="rownames")
convert_orthologs <- function(gene_df, 
                              gene_col="rownames", 
                              input_species, 
                              output_species="human", 
                              drop_nonorths=TRUE, 
                              one_to_one_only=TRUE, 
                              genes_as_rownames=FALSE, 
                              return_dict=FALSE, 
                              invert_dict=FALSE, 
                              verbose=TRUE){ 
  messager("Converting genes:",input_species,"===>",output_species, v=verbose) 
  
  #### Standardise input data ####
  gene_df <- data.frame(as.matrix(gene_df))
  #### Check if previously converted ####
  # If so, skip ahead.
  if(!is_converted(gene_df, verbose=verbose)){
    #### Check gene_col ####
    gene_df <- check_gene_col(gene_df = gene_df, 
                              gene_col = gene_col, 
                              verbose = verbose)
    n_input_genes <- length(unique(gene_df$Gene))
    #### Check Gene_orig ####
    gene_df <- check_gene_orig(gene_df = gene_df, 
                               verbose = verbose)
    #### Map orthologs ####
    gene_df <- map_orthologs(gene_df = gene_df, 
                             gene_col = "Gene", # Set by check_gene_col
                             input_species = input_species, 
                             output_species = output_species,
                             verbose = verbose) 
  } else {
    messager("+ orthologs previously converted.",v=verbose)
    n_input_genes <- length(unique(gene_df$Gene))
  } 
  
  #### Drop non-orthologs ####
  if(drop_nonorths){
    gene_df <- drop_nonorth_genes(gene_df = gene_df,
                                  output_species = output_species,
                                  verbose = verbose)
  }
  #### Drop non-1:1 geness ####
  if(one_to_one_only){
    gene_df <- check_one_to_one(gene_df = gene_df, 
                                verbose = verbose)
  }
  #### Set genes as rownames ####
  if(genes_as_rownames){
    if(!drop_nonorths){
      messager("WARNING: drop_nonorths must =TRUE",
               "in order to set genes_as_rownames=TRUE.")
    }else {
      messager("+ Setting Gene col as rownames...",v=verbose)
      if(!one_to_one_only) stop("Genes must be unique to be row.names.",
                                " Try again with `one_to_one_only=TRUE`")
      rownames(gene_df) <- gene_df$Gene
    }
  }
  #### Report ####
  n_dropped <-n_input_genes-length(unique(gene_df$Gene))
  messager("Genes dropped during inter-species conversion: ",
           formatC(n_dropped,big.mark=","),
           " / ",
           formatC(n_input_genes,big.mark=","),
           " (",format(n_dropped/n_input_genes*100, digits = 4),"%)",
           v=verbose)
  #### Return ####
  if(return_dict){
    dict <- setNames(gene_df$Gene, gene_df$Gene_orig)
    if(invert_dict){dict <- invert_dictionary(dict)}
    return(dict)
  }else{
    return(gene_df)
  } 
}


