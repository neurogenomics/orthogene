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
                      method = c("gprofiler", "homologene"),
                      ensure_filter_nas = FALSE,
                      verbose = TRUE,
                      ...) {

    #### Query gprofiler ####
    if (methods_opts(method = method, gprofiler_opts = TRUE)) {
        tar_genes <- all_genes_gprofiler(
            species = species,
            verbose = verbose,
            ...
        )
    }
    #### Query homologene ####
    if (methods_opts(method = method, homologene_opts = TRUE)) {
        tar_genes <- all_genes_homologene(
            species = species,
            verbose = verbose
        )
    }

    tar_genes <- remove_all_nas(
        dat = tar_genes,
        col_name = "Gene.Symbol",
        verbose = verbose
    )
    #### Report ####
    messager("Returning all", formatC(nrow(tar_genes), big.mark = ","),
        "genes from", paste0(species, "."),
        v = verbose
    )
    return(tar_genes)
}
