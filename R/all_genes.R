#' Get all genes
#'
#' Return all known genes from a given species.
#'
#' References \link[homologene]{homologeneData} or
#' \link[gprofiler2]{gconvert}.
#'
#' @param species Species to get all genes for.
#' Will first be standardised with \code{map_species}.
#' @param method R package to to use for gene mapping:
#' \code{"gprofiler"} (slower but more species and genes) or
#' \code{"homologene"} (faster but fewer species and genes).
#' @param ... Additional arguments to be passed to
#'  \link[gprofiler2]{gconvert} when
#'  \code{method="gprofiler"}.
#' @param ensure_filter_nas Perform an extra check to remove
#' genes that are \code{NA}s of any kind.
#' @param verbose Print messages.
#'
#' @return Table with all gene symbols
#'  from the given \code{species}.
#' @export
#'
#' @examples
#' genome_mouse <- all_genes(species = "mouse")
#' genome_human <- all_genes(species = "human")
all_genes <- function(species,
                      method = c("gprofiler", 
                                 "homologene",
                                 "babelgene"),
                      ensure_filter_nas = FALSE,
                      verbose = TRUE,
                      ...) {
    
    if (methods_opts(method = method, gprofiler_opts = TRUE)) {
        #### Query gprofiler ####
        tar_genes <- all_genes_gprofiler(
            species = species,
            verbose = verbose,
            ...
        )
    } else if (methods_opts(method = method, homologene_opts = TRUE)) {
        #### Query homologene ####
        tar_genes <- all_genes_homologene(
            species = species,
            verbose = verbose
        )
    } else if (methods_opts(method = method, babelgene_opts = TRUE)) {
        #### Query babelgene ####
        tar_genes <- all_genes_babelgene(
            species = species,
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
