all_genes_babelgene <- function(species,
                                verbose = TRUE) {
    
    ### Avoid confusing Biocheck
    taxon_id <- symbol <- NULL
    
    messager("Retrieving all genes using: babelgene.", v = verbose)
    target_id <- map_species(
        species = species,
        output_format = "taxonomy_id", 
        verbose = verbose
    )
    #### Upload babelgene orths to releases (too large for bioc) ####
    tmp <- file.path(tempdir(),"babelgene_orths.rda")
    # ## Create/upload file
    # orths <- babelgene:::orthologs_df
    # ## Add humans as another species
    # human_df <- orths
    # human_df$taxon_id <- 9606
    # human_df$symbol <- human_df$human_symbol
    # human_df$entrez <- human_df$human_entrez
    # human_df$ensembl <- human_df$human_ensembl
    # human_df$support <- NA
    # human_df$support_n <- NA
    # orths <- rbind(orths, unique(human_df))
    # save(orths, file = tmp)
    # piggyback::pb_upload(file = tmp,
    #                      repo = "neurogenomics/orthogene",
    #                      overwrite = TRUE)
    ##### Download file #####
    requireNamespace("piggyback")
    piggyback::pb_download(file = "babelgene_orths.rda", 
                           repo = "neurogenomics/orthogene",
                           dest = tempdir())
    orths <- load_data(tmp)
    tar_genes <- subset(orths, taxon_id == target_id) %>%
        dplyr::rename(taxonomy_id=taxon_id,
                      Gene.Symbol=symbol) 
    messager("Gene table with", formatC(nrow(tar_genes), big.mark = ","),
             "rows retrieved.",
             v = verbose
    )
    return(tar_genes)
}
