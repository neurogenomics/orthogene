all_genes_gprofiler <- function(species,
                                verbose = TRUE,
                                run_map_species = TRUE,
                                ...) {
    # Avoid confusing Biocheck
    name <- NULL
    
    messager("Retrieving all genes using: gprofiler", v = verbose)
    if(run_map_species){
        species <- map_species(
            species = species,
            method = "gprofiler",
            output_format = "id",
            verbose = verbose
        )
    } 
    
    #### Construct all ranges genome-wide ####
    ranges <- all_ranges()
    tar_genes <- gprofiler2::gconvert(
        query = ranges,
        ## organism must be in "mmusculus" format
        organism = unname(species),
        ...
    )
    ### make similar to homologene
    tar_genes <- tar_genes %>% dplyr::rename(Gene.Symbol = name)
    messager("Gene table with", formatC(nrow(tar_genes), big.mark = ","),
             "rows retrieved.",
             v = verbose
    )
    return(tar_genes)
}