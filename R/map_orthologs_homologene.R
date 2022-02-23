#' Map orthologs: homologene
#'
#' Map orthologs from one species to another
#' using \link[homologene]{homologene}.
#'
#'
#' @param genes Gene list.
#' @param ... Additional arguments to be passed
#' to \link[homologene]{homologene}.
#' @inheritParams convert_orthologs
#' @inheritParams homologene::homologene
#'
#' @return Ortholog map \code{data.frame}
#' @importFrom homologene homologene
#' @keywords internal
map_orthologs_homologene <- function(genes,
                                     input_species,
                                     output_species = "human",
                                     verbose = TRUE,
                                     ...) {
    source_id <- map_species(
        species = input_species, 
        method = "homologene",
        output_format = "taxonomy_id",
        verbose = verbose
    )
    target_id <- map_species(
        species = output_species, 
        method = "homologene",
        output_format = "taxonomy_id",
        verbose = verbose
    )
    gene_map <- homologene::homologene(
        genes = genes,
        inTax = source_id,
        outTax = target_id,
        ...
    )
    colnames(gene_map) <- c(
        "input_gene", "ortholog_gene",
        "input_geneID", "ortholog_geneID"
    )
    return(gene_map)
}
