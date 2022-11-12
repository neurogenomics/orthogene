#' Report orthologs
#'
#' Identify the number of orthologous genes between two species.
#'
#' @param target_species Target species.
#' @param reference_species Reference species.
#'
#' @param method_all_genes R package to to use in
#' \link[orthogene]{all_genes} step:
#' \itemize{
#' \item{\code{"gprofiler"} : Slower but more species and genes.}
#' \item{\code{"homologene"} : Faster but fewer species and genes.}
#' \item{\code{"babelgene"} : Faster but fewer species and genes.
#' Also gives consensus scores for each gene mapping based on a
#'  several different data sources.}
#' }
#'
#' @param method_convert_orthologs R package to to use in
#' \link[orthogene]{convert_orthologs} step:
#' \itemize{
#' \item{\code{"gprofiler"} : Slower but more species and genes.}
#' \item{\code{"homologene"} : Faster but fewer species and genes.}
#' \item{\code{"babelgene"} : Faster but fewer species and genes.
#' Also gives consensus scores for each gene mapping based on a
#'  several different data sources.}
#' }
#'
#' @param return_report Return just the ortholog mapping
#' between two species (\code{FALSE}) or return both the
#'  ortholog mapping as well a \code{data.frame}
#'  of the report statistics (\code{TRUE}).
#'
#' @param round_digits Number of digits to round to when printing percentages.
#' @param mc.cores Number of cores to parallelise each
#'  \code{target_species} with. 
#' @inheritParams convert_orthologs
#'
#' @returns A list containing: 
#' \itemize{
#' \item{map : }{A table of inter-species gene mappings.}
#' \item{report : }{A list of aggregate orthology report statistics.}
#' }
#' If >1 \code{target_species} are provided, then a table of 
#' aggregated \code{report} statistics concatenated across species 
#' will be returned instead. 
#' @export
#' @importFrom dplyr n_distinct
#' @importFrom data.table rbindlist
#' @importFrom parallel mclapply
#' @examples
#' orth_fly <- orthogene::report_orthologs(
#'     target_species = "fly",
#'     reference_species = "human"
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
                             mc.cores = 1,
                             verbose = TRUE,
                             ...) {
    # echoverseTemplate:::source_all(packages = "dplyr")
    # echoverseTemplate:::args2vars(report_orthologs)
    
    
    #### Recursion ####
    if(length(target_species)>1){
        messager("Gathering ortholog reports.",v=verbose)
        orth_report <- parallel::mclapply(target_species, function(s){
            if(verbose) message_parallel("\n-- ",s)
            tryCatch({
                report_orthologs(
                    target_species = s, 
                    reference_species = reference_species, 
                    method_all_genes = method_all_genes,
                    method_convert_orthologs = method_convert_orthologs)$report
            }, error = function(e) NULL)
        }, mc.cores = mc.cores) |> data.table::rbindlist()
        return(orth_report)
    }
    
    #### Standardise args ####
    method_convert_orthologs <- tolower(method_convert_orthologs[1])
    method_all_genes <- tolower(method_all_genes[1])
    #### Save original target_species name ####
    input_species <- target_species 
    #### Check species here to see if they're synonymous ####
    species1 <- map_species(species = target_species,
                            method = method_all_genes,
                            verbose = FALSE) |> unname() 
    species2 <- map_species(species = reference_species,
                            method = method_all_genes,
                            verbose = FALSE) |> unname() 
    #### Species are the same #### 
    if(species1==species2){
        gene_df <- all_genes(species = reference_species, 
                             method = method_all_genes,
                             run_map_species = TRUE,
                             verbose = verbose)
        gene_df$ortholog_gene <- gene_df$Gene.Symbol
        tar_genes <- ref_genes <- gene_df
        message("--")
    } else {
        #### Species are different ####
        #### Get full genomes for each species #### 
        tar_genes <- all_genes(
            species = target_species,
            method = method_all_genes,
            run_map_species = TRUE,
            verbose = verbose
        ) 
        message("--")
        ref_genes <- all_genes(
            species = reference_species,
            method = method_all_genes,
            run_map_species = TRUE,
            verbose = verbose
        )
        message("--")
        #### Map genes from target to references species ####
        gene_df <- convert_orthologs(
            gene_df = tar_genes,
            gene_input = "Gene.Symbol",
            gene_output = "columns",
            agg_fun = NULL,
            standardise_genes = standardise_genes,
            input_species = target_species,
            output_species = reference_species,
            method = method_convert_orthologs,
            drop_nonorths = drop_nonorths,
            non121_strategy = non121_strategy,
            verbose = verbose,
            ...
        )
        message("--")
    }
    messager("\n=========== REPORT SUMMARY ===========\n",v=verbose)
    one2one_orthologs <- dplyr::n_distinct(gene_df$ortholog_gene)
    target_total_genes <- dplyr::n_distinct(tar_genes$Gene.Symbol)
    reference_total_genes <- dplyr::n_distinct(ref_genes$Gene.Symbol)
    target_percent <- round(one2one_orthologs / target_total_genes * 100,
        digits = round_digits
    )
    reference_percent <- round(one2one_orthologs / reference_total_genes * 100,
        digits = round_digits
    )
    messager(
        formatC(one2one_orthologs, big.mark = ","), "/",
        formatC(target_total_genes, big.mark = ","),
        paste0("(", target_percent, "%)"),
        "target_species genes remain after ortholog conversion.",
        v=verbose
    )
    messager(
        formatC(one2one_orthologs, big.mark = ","), "/",
        formatC(reference_total_genes, big.mark = ","),
        paste0("(", reference_percent, "%)"),
        "reference_species genes remain after ortholog conversion.",
        v=verbose
    )
    if (return_report) {
        list(
            map = gene_df,
            report = data.frame(
                "input_species" = input_species,
                "target_species" = species1,
                "target_total_genes" = target_total_genes,
                "reference_species" = species2,
                "reference_total_genes" = reference_total_genes,
                "one2one_orthologs" = one2one_orthologs,
                "target_percent" = target_percent,
                "reference_percent" = reference_percent
            )
        )
    } else {
        return(gene_df)
    }
}
