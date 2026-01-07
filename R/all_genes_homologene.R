all_genes_homologene <- function(species,
                                 run_map_species = TRUE, 
                                 force = FALSE,
                                 verbose = TRUE) {

    ### Avoid confusing Biocheck
    Taxonomy <- NULL
    
    start1 <- Sys.time()

    messager("Retrieving all genes using: homologene.", v = verbose)
    if(run_map_species){
        species <- map_species(
            species = species,
            output_format = "taxonomy_id", 
            method = "homologene",
            verbose = verbose
        )
    } 
    
    save_path <- get_cache_save_path(fn="all_genes",
                                     species=species,
                                     method="homologene")
    
    if (file.exists(save_path) && isFALSE(force)){
        messager("Using cached file:",save_path)
        tar_genes <- data.table::fread(save_path) 
        return (tar_genes)
    }
    
    
    tar_genes <- subset(
        homologene::homologeneData,
        Taxonomy == species
    ) |> dplyr::rename(taxonomy_id=Taxonomy)
    messager("Gene table with", formatC(nrow(tar_genes),big.mark = ","),
             "rows retrieved.",
        v = verbose
    )
    
    
    tar_genes$time <- as.numeric(difftime(Sys.time(), start1, units = "secs")) 
    
    ### Cache file ###
    messager("Caching file -->",save_path, v=verbose) 
    data.table::fwrite(tar_genes, file = save_path, sep=",")
    
    return(tar_genes)
}
