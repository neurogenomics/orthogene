#' Map genes from one species to another
#'
#' Currently supports 700+ species.
#' See \code{map_species()} for a full list of available species.
#' 
#' @param gene_df Data.frame containing the genes symbols of the input species.
#' @param gene_col Character string indicating either the 
#' input species' gene symbols are in a column with the 
#' input species gene symbols (\code{gene_col="<gene_col_name>"}) 
#' or are the row names (\code{gene_col="rownames"}) or
#' column names (\code{gene_col="colnames"}).
#' @param standardise_genes If \code{TRUE} genes will first be standardised 
#' to HGNC symbols using \code{gprofiler2::gconvert}. 
#' This will add a new column to \code{gene_df} 
#' called "input_gene_standard".  
#' @param input_species Name of the input species (e.g., "mouse","fly"). 
#' See \code{taxa_id_dict()} for a full list of available species.
#' @param output_species Name of the output species (e.g. "human").
#' @param drop_nonorths Drop genes that don't have an ortholog 
#'  in the \code{output_species}. 
#' @param one_to_one_only Drop genes that don't have a 1:1 mapping 
#' between input species and human 
#' (i.e. drop genes with multiple human orthologs).
#' @param method R package to to use for gene mapping: 
#' \code{"gorth"} (slower but more reference species) or 
#' \code{"homologene"} (faster but fewer reference species). 
#' @param genes_as_rownames Whether to return the data.frame 
#' with the row names set to the human orthologs.
#' @param as_sparse If \code{obj} is a matrix, 
#' it can be converted to a sparse matrix. 
#' @param sort_rows Sort rows alphanumerically.
#' @param return_dict Return a dictionary (named list) of gene mappings, 
#' where \code{names} are the original gene names and 
#'  items are the new gene names. If \code{return_dict=FALSE}, 
#'  instead returns mappings as a data.frame. 
#' @param invert_dict If \code{return_dict=TRUE}, setting \code{invert_dict} 
#' switches the names and items in the dictionary.
#' @param verbose Print messages.
#' @param ... Additional arguments to be passed to 
#' \code{gprofiler2::gorth()} or 
#' \code{homologene::homologene()}.
#' 
#' @return Data.frame with the gene symbols of the input species ("Gene_orig") 
#' and converted human orthologs ("Gene").
#' @export
#' @import homologene
#' @import Matrix
#' @importFrom dplyr select rename all_of 
#' @importFrom stats setNames complete.cases
#' @importFrom methods as 
#' @examples 
#' data("exp_mouse")
#' gene_df <- convert_orthologs(gene_df = exp_mouse,
#'                              input_species="mouse",
#'                              genes_as_rownames=TRUE)
convert_orthologs <- function(gene_df, 
                              gene_col="rownames", 
                              standardise_genes=FALSE,
                              input_species, 
                              output_species="human",
                              method=c("homologene","gorth"),
                              drop_nonorths=TRUE, 
                              one_to_one_only=TRUE, 
                              genes_as_rownames=FALSE, 
                              as_sparse=FALSE, 
                              sort_rows=FALSE,
                              return_dict=FALSE, 
                              invert_dict=FALSE, 
                              verbose=TRUE,
                              ...){ 
  
  messager("\nConverting genes:",input_species,"===>",output_species,"\n",v=verbose) 
  
  #### Standardise input data #### 
  check_gene_df_type_out <- check_gene_df_type(gene_df = gene_df, 
                                               gene_col = gene_col,
                                               verbose = verbose)
  gene_df <- check_gene_df_type_out$gene_df; 
  gene_col <- check_gene_df_type_out$gene_col;
 
 
  #### Check if previously converted ####
  # If so, skip ahead.
  if(!is_converted(gene_df, verbose=verbose)){
    #### Check gene_col ####
    genes <- extract_gene_list(gene_df = gene_df, 
                               gene_col = gene_col, 
                               verbose = verbose)
    n_input_genes <- length(unique(genes)) 
    #### Map orthologs ####
    gene_map <- map_orthologs(genes = genes,  
                              input_species = input_species, 
                              output_species = output_species,
                              standardise_genes = standardise_genes,
                              method = method,
                              verbose = verbose,
                              ...) 
  } else {
    messager("Detected that gene_df was previously converted to orthologs.\n",
             "Skipping map_orthologs step.",v=verbose)
    genes <- gene_df$input_gene
    n_input_genes <- length(unique(genes))
    gene_map <- gene_df
  } 
  
  #### Drop non-orthologs ####
  if(drop_nonorths){
    gene_map <- drop_nonorth_genes(gene_map = gene_map,
                                   output_species = output_species,
                                   verbose = verbose)
  }
  #### Drop non-1:1 genes ####
  if(one_to_one_only){
    gene_map <- check_one_to_one(gene_map = gene_map, 
                                 verbose = verbose)
  }
  
  #### Remove any lingering NAs ####
  gene_map <- gene_map[stats::complete.cases(gene_map),] 
  
  #### Set genes as rownames ####
  if(genes_as_rownames){
    if(!drop_nonorths){
      messager("WARNING: drop_nonorths must =TRUE",
               "in order to set genes_as_rownames=TRUE.")
    }else {
      messager("+ Setting ortholog_gene col as rownames...",v=verbose)
      if(!one_to_one_only) stop("Genes must be unique to be row.names.",
                                " Try again with one_to_one_only=TRUE")
      rownames(gene_map) <- gene_map$ortholog_gene
    }
  } 
  ##### Subset and add new genes cols/rownames ####
  format_gene_df_out <- format_gene_df(gene_df = gene_df, 
                                       gene_map = gene_map, 
                                       genes = genes,
                                       genes_as_rownames = genes_as_rownames, 
                                       as_sparse = as_sparse,
                                       sort_rows = sort_rows,
                                       standardise_genes = standardise_genes, 
                                       verbose = verbose)
  gene_df2 <- format_gene_df_out$gene_df2;
  genes2 <- format_gene_df_out$genes2;  
  #### Report ####
  report_gene_map(gene_df2 = gene_df2, 
                  n_input_genes = n_input_genes,
                  verbose = verbose) 
  #### Return ####
  if(return_dict){
    ##### Return gene dictionary ####
    gene_map2 <- gene_map[gene_map$input_gene %in% genes2,]
    dict <- setNames(gene_map2$ortholog_gene, gene_map2$input_gene) 
    if(invert_dict){dict <- invert_dictionary(dict)}
    return(dict)
  } else{
    ##### Return gene_df ####  
    return(gene_df2)
  } 
}


