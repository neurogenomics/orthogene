#' Map orthologs 
#' 
#' Map orthologs from one species to another.
#' 
#' \code{map_orthologs()} is a core function within 
#' \code{convert_orthologs()}, but does not have many
#' of the extra checks, such as \code{one_to_one_only})
#' and \code{drop_nonorths}. 
#' 
#' @param genes can be a mixture of any format
#'  (HGNC symbols, ENSEMBL, UCSC, etc.)
#'  and will be automatically converted to
#'   standardised HGNC symbol format.
#' @inheritParams convert_orthologs 
#' 
#' @return Ortholog map \code{data.frame} with at
#'  least the columns "input_gene" and "ortholog_gene".
#' @export
#' 
#' @examples 
#' data("exp_mouse")
#' gene_map <- map_orthologs(genes=rownames(exp_mouse),
#'                           input_species="mouse")
map_orthologs <- function(genes,
                          standardise_genes=FALSE,
                          input_species,
                          output_species="human",
                          method=c("homologene","gorth"), 
                          verbose=TRUE,
                          ...){
  messager("Converting",input_species,"==>",output_species,
           "orthologs using",method[1],v=verbose)
  
  #### Standardise gene names first ####
  if(standardise_genes){
    messager("Standardising gene names first.",v=verbose)
    syn_map <- map_genes(genes = genes, 
                         species = input_species, 
                         filter_na = FALSE, 
                         verbose = verbose)
    genes <- syn_map$name 
  }
 
  
  #### Select mapping method ####
  # Both methods will return a dataframe with at least the columns
  # "input_gene" and "ortholog_gene" 
  if(tolower(method[1])=="gorth"){
    gene_map <- map_orthologs_gorth(genes=genes,
                                    input_species=input_species, 
                                    output_species=output_species, 
                                    verbose=verbose,
                                    ...) 
  } 
  if(tolower(method[1])=="homologene"){
     gene_map <- map_orthologs_homologene(genes=genes,
                                          input_species=input_species, 
                                          output_species=output_species, 
                                          verbose=verbose,
                                          ...)
  }  
  #### Add back in original gene names ####
  if(standardise_genes && exists("syn_map")){
    gene_map <- add_synonyms(gene_map = gene_map,
                             syn_map = syn_map)
  } 
  return(gene_map)
}