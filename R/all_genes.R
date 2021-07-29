#' Get all genes
#' 
#' Return all known genes from a given species. 
#' 
#' References \code{homologene::homologeneData}.
#' 
#' @param species Species to get genes for. 
#' Will first be standardised with \code{map_species}.
#' @param verbose Print messages.
#' 
#' @return Gene table  
#' @export
#' 
#' @examples 
#' genome_mouse <- all_genes(species="mouse")
#' genome_human <- all_genes(species="human")
all_genes <- function(species,
                      verbose=TRUE){
  ### Avoid confusing Biocheck
  Taxonomy <- NULL 
  target_id <- map_species(species = species, 
                           output_format = "taxonomy_id",
                           verbose=verbose) 
  tar_genes <- subset(homologene::homologeneData, 
                      Taxonomy==target_id)
  messager("Returning all",formatC(nrow(tar_genes), big.mark = ","),
           "genes from",paste0(species,"."),v=verbose)
  return(tar_genes)
}
