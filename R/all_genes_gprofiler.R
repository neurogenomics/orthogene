all_genes_gprofiler <- function(species,
                                verbose=TRUE,
                                ...){ 
  # Avoid confusing Biocheck 
  name <- NULL; 
  
  messager("Retrieving all genes using: gprofiler",v=verbose)
  mapped_species <- map_species(species = species, 
                                verbose = verbose)
  #### Construct all ranges genome-wide ####
  ranges <- all_ranges()
  tar_genes <- gprofiler2::gconvert(query = ranges,
                                    organism = mapped_species,
                                    ...) 
  ### make similar to homologene
  tar_genes <- dplyr::rename(tar_genes, Gene.Symbol=name) 
  messager("Gene table with",nrow(tar_genes),"rows retrieved.",
           v=verbose)
  return(tar_genes)
}