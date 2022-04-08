#' Get all genes: babelgene
#' 
#' Get all genes for a given species using the method "babelgene".
#' 
#' @source \href{https://github.com/igordot/babelgene/issues/2}{
#' babelgene::orthologs_df version differences}  
#' 
#' @param save_dir Directory to save babelgene mapping files to.
#' @param use_old Use an old version of \code{babelgene::orthologs_df} 
#' (stored on GitHub Releases) for consistency.
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
                                use_old = FALSE,
                                min_support = 1,
                                verbose = TRUE) {
    
    ### Avoid confusing Biocheck
    taxon_id <- symbol <- NULL
    
    messager("Retrieving all genes using: babelgene.", v = verbose)
    if(run_map_species){
        source_id <- map_species(
            species = species,
            output_format = "taxonomy_id", 
            method = "babelgene",
            verbose = verbose
        )
    } else {source_id <- species}
    #### Retrieve updated local version included with babelgene ####
    if(isFALSE(use_old)){ 
        messager("Preparing babelgene::orthologs_df.",v=verbose)
        orths <- base::get("orthologs_df", asNamespace("babelgene"))
        # mgi_orths <- base::get("mgi_orthologs_df", asNamespace("babelgene")) 
        ## Add humans as another species
        human_df <- orths
        human_df$taxon_id <- 9606
        human_df$symbol <- human_df$human_symbol
        human_df$entrez <- human_df$human_entrez
        human_df$ensembl <- human_df$human_ensembl
        human_df$support <- NA
        human_df$support_n <- NA 
        orths <- rbind(orths, unique(human_df)) 
    #### Upload babelgene orths to releases (too large for data/ ) ####
    #     save(orths, file = tmp)
    #     piggyback::pb_upload(file = tmp,
    #                          repo = "neurogenomics/orthogene",
    #                          overwrite = TRUE)
    
    #### Download from GitHub releases #####
    } else {
        dir.create(save_dir, showWarnings = FALSE, recursive = TRUE)
        tmp <- file.path(save_dir,"babelgene_orths.rda")
        requireNamespace("piggyback")
        piggyback::pb_download(file = "babelgene_orths.rda",
                               repo = "neurogenomics/orthogene",
                               dest = save_dir)
        get_data_check(tmp = tmp)
        orths <- load_data(tmp)
    } 
    #### Filter by species ####
    tar_genes <- subset(orths, taxon_id == source_id) %>%
        dplyr::rename(taxonomy_id=taxon_id,
                      Gene.Symbol=symbol) 
    if(min_support>0){
        orths <- subset(orths, support>=min_support)
    }
    messager("Gene table with", formatC(nrow(tar_genes), big.mark = ","),
             "rows retrieved.",
             v = verbose
    )
    return(tar_genes)
}
