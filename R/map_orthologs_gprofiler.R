#' Map orthologs: gprofiler
#'
#' Map orthologs from one species to another
#' using \link[gprofiler2]{gorth}.
#'
#' "\code{mthreshold} is used to set the maximum number
#' of ortholog names per gene to show. This is useful to handle
#'  the problem of having many orthologs per gene
#'  (most of them uninformative). The function tries to
#'   find the most informative by selecting the most popular ones."\cr
#' ~ From
#' \href{https://cran.r-project.org/web/packages/gprofiler2/vignettes/gprofiler2.html}{
#'  \code{gprofiler2} vignette}\cr
#'
#' Available namespaces for the \code{numeric_ns} argument can be found
#' \href{https://biit.cs.ut.ee/gprofiler/page/namespaces-list}{here}.
#'
#' @param genes Gene list.
#' @param filter_na Logical indicating whether to
#'  filter out results without a corresponding target name.
#'  (\emph{DEFAULT} is \code{FALSE}, so that \code{NA}s
#'  can be handled by \pkg{orthogene}).
#' @param ... Additional arguments to be passed to
#' \link[gprofiler2]{gorth}.
#' @inheritParams convert_orthologs
#' @inheritParams gprofiler2::gorth
#'
#' @return Ortholog map \code{data.frame}
#' @importFrom gprofiler2 gorth
#' @importFrom  dplyr rename
#' @keywords internal
map_orthologs_gprofiler <- function(genes,
                                    input_species,
                                    output_species = "human",
                                    filter_na = FALSE,
                                    mthreshold = Inf,
                                    verbose = TRUE,
                                    ...) {
    ## Avoid confusing Biocheck
    input <- ortholog_name <- NULL;
    ### Can take any mixtures of gene name types/IDs
    # genes <- c("Klf4", "Sox2", "71950",
    #            "ENSMUSG00000012396","ENSMUSG00000074637")
    source_organism <- map_species(
        species = input_species,
        method = "gprofiler",
        output_format = "id",
        verbose = verbose
    )
    target_organism <- map_species(
        species = output_species,
        method = "gprofiler",
        output_format = "id",
        verbose = verbose
    )
    gene_map <- gprofiler2::gorth(
        query = genes,
        ## organism must be in "mmusculus" format
        source_organism = source_organism,
        target_organism = target_organism,
        mthreshold = mthreshold,
        filter_na = filter_na,
        ...
    )
    #### Rename to make comparable to other mapping methods ####
    gene_map <- dplyr::rename(gene_map,
        input_gene = input,
        ortholog_gene = ortholog_name
    )
    return(gene_map)
}
