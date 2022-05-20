#' Get all genes
#'
#' Return all known genes from a given species.
#'
#' References \link[homologene]{homologeneData} or
#' \link[gprofiler2]{gconvert}.
#'
#' @param species Species to get all genes for.
#' Will first be standardised with \code{map_species}. 
#' @param ensure_filter_nas Perform an extra check to remove
#' genes that are \code{NA}s of any kind.
#' @param run_map_species Standardise \code{species} names with 
#' \link[orthogene]{map_species} first (Default: \code{TRUE}).  
#' @inheritParams convert_orthologs
#'
#' @returns Table with all gene symbols
#'  from the given \code{species}.
#'  
#' @export
#' @examples
#' genome_mouse <- all_genes(species = "mouse")
#' genome_human <- all_genes(species = "human")
all_genes <- function(species,
                      method = c("gprofiler", 
                                 "homologene",
                                 "babelgene"),
                      ensure_filter_nas = FALSE,
                      run_map_species = TRUE,
                      verbose = TRUE,
                      ...) {
    method <- tolower(method)[1]
    if (methods_opts(method = method, gprofiler_opts = TRUE)) {
        #### Query gprofiler ####
        tar_genes <- all_genes_gprofiler(
            species = species,
            run_map_species = run_map_species,
            verbose = verbose,
            ...
        )
    } else if (methods_opts(method = method, homologene_opts = TRUE)) {
        #### Query homologene ####
        tar_genes <- all_genes_homologene( 
            species = species,
            run_map_species = run_map_species,
            verbose = verbose
        )
    } else if (methods_opts(method = method, babelgene_opts = TRUE)) {
        #### Query babelgene ####
        tar_genes <- all_genes_babelgene(
            species = species,
            run_map_species = run_map_species,
            verbose = verbose
        )
    } else {
        messager(paste0("method='",method,"' not recognised."),
                 "Must be one of:\n",
                 paste("-",c("gprofiler", 
                         "homologene",
                         "babelgene"), collapse = "\n "))
        messager("Setting method='gprofiler' by default.",v=verbose)
        #### Query gprofiler ####
        tar_genes <- all_genes_gprofiler(
            species = species,
            run_map_species = run_map_species,
            verbose = verbose,
            ...
        )
    }
    ### Clean genes ####
    if(ensure_filter_nas){
        tar_genes <- remove_all_nas(
            dat = tar_genes,
            col_name = "Gene.Symbol",
            verbose = verbose
        )
    } 
    #### Report ####
    messager("Returning all", formatC(nrow(tar_genes), big.mark = ","),
        "genes from", paste0(species, "."),
        v = verbose
    )
    return(tar_genes)
}
