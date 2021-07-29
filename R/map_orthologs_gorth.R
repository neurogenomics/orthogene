#' Map orthologs: gorth
#' 
#' Map orthologs from one species to another
#' using \code{gprofiler2::gorth()}. 
#' 
#' @param genes Gene list.
#' @param ... Additional arguments to be passed to
#' \code{gprofiler2::gorth()}.
#' @inheritParams convert_orthologs
#' @inheritParams gprofiler2::gorth
#' 
#' @return Ortholog map \code{data.frame}
#' @importFrom gprofiler2 gorth 
#' @importFrom  dplyr rename  
map_orthologs_gorth <- function(genes,
                                input_species,
                                output_species="human", 
                                filter_na=FALSE, 
                                verbose=TRUE,
                                ...){
  ## Avoid confusing Biocheck
  input <- ortholog_name <- NULL;
  # genes <- c("Klf4", "Sox2", "71950","ENSMUSG00000012396","ENSMUSG00000074637") 
  ### Can take any mixtures of gene name types/IDs
  ### Namespaces to query: https://biit.cs.ut.ee/gprofiler/page/namespaces-list 
  source_organism <- map_species(species = input_species, 
                                 verbose = verbose)
  target_organism <- map_species(species = output_species, 
                                 verbose = verbose)
  gene_map <- gprofiler2::gorth(query = genes, 
                                source_organism = source_organism, 
                                target_organism = target_organism,  
                                filter_na = filter_na,
                                ...)
  #### Rename to make comparable to other mapping methods ####
  gene_map <- dplyr::rename(gene_map, 
                            input_gene=input, 
                            ortholog_gene=ortholog_name)
  return(gene_map) 
}