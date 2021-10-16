#' Report orthologs
#'
#' Identify the number of orthologous genes between two species.
#'
#' @param target_species Target species.
#' @param reference_species Reference species.
#'
#' @param method_all_genes R package to to use in
#' \link[orthogene]{all_genes} step:
#' \code{"gprofiler"} (slower but more species and genes) or
#' \code{"homologene"} (faster but fewer species and genes).
#'
#' @param method_convert_orthologs R package to to use in
#' \link[orthogene]{convert_orthologs} step:
#' \code{"gprofiler"} (slower but more species and genes) or
#' \code{"homologene"} (faster but fewer species and genes).
#'
#' @param return_report Return just the ortholog mapping
#' between two species (\code{FALSE}) or return both the
#'  ortholog mapping as well a \code{data.frame}
#'  of the report statistics (\code{TRUE}).
#'
#' @param round_digits Number of digits to round to when printing percentages.
#' @inheritParams convert_orthologs
#'
#' @return List of ortholog report statistics
#' @export
#' @importFrom dplyr n_distinct
#' @examples
#' orth_fly <- report_orthologs(
#'     target_species = "fly",
#'     reference_species = "human"
#' )
report_orthologs <- function(target_species = "mouse",
                             reference_species = "human",
                             standardise_genes = FALSE,
                             method_all_genes = c("gprofiler", "homologene"),
                             method_convert_orthologs = c(
                                 "gprofiler",
                                 "homologene"
                             ),
                             drop_nonorths = TRUE,
                             non121_strategy = "drop_both_species",
                             round_digits = 2,
                             return_report = TRUE,
                             verbose = TRUE,
                             ...) {

    #### Get full genomes for each species ####
    tar_genes <- all_genes(
        species = target_species,
        method = method_all_genes,
        verbose = verbose
    )
    ref_genes <- all_genes(
        species = reference_species,
        method = method_all_genes,
        verbose = verbose
    )
    #### Map genes from target to references species ####
    gene_df <- convert_orthologs(
        gene_df = tar_genes,
        gene_input = "Gene.Symbol",
        gene_output = "columns",
        standardise_genes = standardise_genes,
        input_species = target_species,
        output_species = reference_species,
        method = method_convert_orthologs[1],
        drop_nonorths = drop_nonorths,
        non121_strategy = non121_strategy,
        verbose = verbose,
        ...
    )

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
                "target_species" = target_species,
                "target_total_genes" = target_total_genes,
                "reference_species" = reference_species,
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
