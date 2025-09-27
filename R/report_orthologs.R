#' Report orthologs
#'
#' Identify the number of orthologous genes between two species.
#'
#' @param target_species Target species.
#' @param reference_species Reference species.
#'
#' @param method_all_genes Package to use in the
#'   \link[orthogene]{all_genes} step:
#'   \describe{
#'     \item{\code{"gprofiler"}}{Slower, but covers more species and genes.}
#'     \item{\code{"homologene"}}{Faster, but covers fewer species and genes.}
#'     \item{\code{"babelgene"}}{Faster, fewer species/genes; also provides
#'       consensus scores for each mapping from multiple data sources.}
#'   }
#'
#' @param method_convert_orthologs Package to use in the
#'   \link[orthogene]{convert_orthologs} step:
#'   \describe{
#'     \item{\code{"gprofiler"}}{Slower, but covers more species and genes.}
#'     \item{\code{"homologene"}}{Faster, but covers fewer species and genes.}
#'     \item{\code{"babelgene"}}{Faster, fewer species/genes; also provides
#'       consensus scores for each mapping from multiple data sources.}
#'   }
#'
#' @param return_report If \code{FALSE}, return only the ortholog mapping
#'   between the two species. If \code{TRUE}, return both the ortholog mapping
#'   and a \code{data.frame} of report statistics.
#' @param round_digits Number of digits to round to when printing percentages.
#' @param mc.cores Number of cores to parallelize across \code{target_species}.
#' @param ref_genes A table of all genes for \code{reference_species}.
#'   If \code{NULL} (default), this is created via
#'   \link[orthogene]{all_genes}.
#' @inheritParams convert_orthologs
#' @inheritDotParams convert_orthologs
#'
#' @return
#' A list containing:
#' \describe{
#'   \item{map}{A table of inter-species gene mappings.}
#'   \item{report}{A list of aggregate orthology report statistics.}
#' }
#' If more than one \code{target_species} is provided, the function returns a
#' table of aggregated \code{report} statistics concatenated across species.
#'
#' @export
#' @importFrom dplyr n_distinct
#' @importFrom data.table rbindlist setcolorder `:=`
#' @importFrom parallel mclapply
#' @examples
#' orth_fly <- report_orthologs(
#'   target_species = "fly",
#'   reference_species = "human"
#' ) 
report_orthologs <- function(target_species = "mouse",
                             reference_species = "human",
                             standardise_genes = FALSE,
                             method_all_genes = c(
                                 "homologene",
                                 "gprofiler", 
                                 "babelgene"
                             ),
                             method_convert_orthologs = method_all_genes,
                             drop_nonorths = TRUE,
                             non121_strategy = "drop_both_species",
                             round_digits = 2,
                             return_report = TRUE,
                             ref_genes = NULL,
                             mc.cores = 1,
                             verbose = TRUE,
                             ...) {
    
    # devoptera::args2vars(report_orthologs)
    
    messager("Gathering ortholog reports.",v=verbose)
    #### Collect ref_genes just once ####
    ref_genes <- all_genes(
        species = reference_species,
        method = method_all_genes,
        run_map_species = TRUE,
        verbose = verbose
    )
    #### Iterate over other species ####
    out <- parallel::mclapply(target_species,
                              function(s){
        if(verbose) message_parallel("\n-- ",s)  
        report_orthologs_i(
            target_species = s,
            reference_species = reference_species,
            standardise_genes = standardise_genes,
            method_all_genes = method_all_genes,
            method_convert_orthologs = method_convert_orthologs,
            drop_nonorths = drop_nonorths,
            non121_strategy = non121_strategy,
            round_digits = round_digits,
            return_report = return_report,
            ref_genes = ref_genes,
            mc.cores = mc.cores,
            verbose = verbose) 
    }, mc.cores = mc.cores) 
    #### Merge all map items ####
    map <- lapply(out, function(x){
        if(isTRUE(return_report)){
            x$map
        } else {
            x
        }
    }) |> data.table::rbindlist(fill = TRUE) 
    #### Merge all report items and return #####
    if(isTRUE(return_report)){
        report <- lapply(out, function(x){
            x$report
        }) |> data.table::rbindlist(fill = TRUE)
        return(list(map=map,
                    report=report))
    }  else {
        return(map)
    }
}
