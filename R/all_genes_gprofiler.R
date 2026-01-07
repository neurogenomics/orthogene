all_genes_gprofiler <- function(species,
                                verbose = TRUE,
                                run_map_species = TRUE,
                                force = FALSE,
                                ...) {
    # Avoid confusing Biocheck
    name <- NULL

    start1 <- Sys.time()
    
    messager("Retrieving all genes using: gprofiler", v = verbose)
    if(run_map_species){
        species <- map_species(
            species = species,
            method = "gprofiler",
            output_format = "id",
            verbose = verbose
        )
    } 
    
    save_path <- get_cache_save_path(fn="all_genes",
                                     species=species,
                                     method="gprofiler")
    
    if (file.exists(save_path) && isFALSE(force)){
        messager("Using cached file:",save_path)
        tar_genes <- data.table::fread(save_path) 
        return (tar_genes)
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
    tar_genes <- tar_genes |> dplyr::rename(Gene.Symbol = name)
    messager("Gene table with", formatC(nrow(tar_genes), big.mark = ","),
             "rows retrieved.",
        v = verbose
    )
    
    if (!is.null(tar_genes)){
        tar_genes$time <- as.numeric(difftime(Sys.time(), start1, units = "secs"))     
    }
    
    
    ### Cache file ###
    messager("Caching file -->",save_path, v=verbose) 
    data.table::fwrite(tar_genes, file = save_path, sep=",")
    
    return(tar_genes)
}
