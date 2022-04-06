all_genes_homologene <- function(species,
                                 run_map_species = TRUE,
                                 verbose = TRUE) {
    
    ### Avoid confusing Biocheck
    Taxonomy <- NULL
    
    messager("Retrieving all genes using: homologene.", v = verbose)
    if(run_map_species){
        species <- map_species(
            species = species,
            output_format = "taxonomy_id", 
            method = "homologene",
            verbose = verbose
        )
    } 
    tar_genes <- subset(
        homologene::homologeneData,
        Taxonomy == species
    ) %>% dplyr::rename(taxonomy_id=Taxonomy)
    messager("Gene table with", formatC(nrow(tar_genes),big.mark = ","),
             "rows retrieved.",
             v = verbose
    )
    return(tar_genes)
}
