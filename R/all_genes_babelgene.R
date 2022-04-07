#' Get all genes: babelgene
#' 
#' Get all genes for a given species using the method "babelgene".
#' 
#' @param save_dir Directory to save babelgene mapping files to.
#' @inheritParams all_genes
#' 
#' @returns All genes.
#' 
#' @keywords internal
#' @importFrom tools R_user_dir
all_genes_babelgene <- function(species,
                                run_map_species = TRUE,
                                save_dir = tools::R_user_dir("orthogene",
                                                             which="cache"),
                                verbose = TRUE) {
    
    ### Avoid confusing Biocheck
    taxon_id <- symbol <- NULL
    
    messager("Retrieving all genes using: babelgene.", v = verbose)
    if(run_map_species){
        target_id <- map_species(
            species = species,
            output_format = "taxonomy_id", 
            method = "babelgene",
            verbose = verbose
        )
    } else {target_id <- species}
   
    #### Upload babelgene orths to releases (too large for bioc) ####
    dir.create(save_dir, showWarnings = FALSE, recursive = TRUE)
    tmp <- file.path(save_dir,"babelgene_orths.rda")
    # {
    #     ## Create/upload file
    #     orths <- babelgene:::orthologs_df
    #     ## Add humans as another species
    #     human_df <- orths
    #     human_df$taxon_id <- 9606
    #     human_df$symbol <- human_df$human_symbol
    #     human_df$entrez <- human_df$human_entrez
    #     human_df$ensembl <- human_df$human_ensembl
    #     human_df$support <- NA
    #     human_df$support_n <- NA
    #     orths <- rbind(orths, unique(human_df))
    #     save(orths, file = tmp)
    #     piggyback::pb_upload(file = tmp,
    #                          repo = "neurogenomics/orthogene",
    #                          overwrite = TRUE)
    # }
    ##### Download file #####
    requireNamespace("piggyback")
    piggyback::pb_download(file = "babelgene_orths.rda", 
                           repo = "neurogenomics/orthogene",
                           dest = save_dir)
    get_data_check(tmp = tmp)
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
