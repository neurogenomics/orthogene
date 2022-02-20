#' Map orthologs
#'
#' Map orthologs from one species to another.
#'
#' \code{map_orthologs()} is a core function within
#' \code{convert_orthologs()}, but does not have many
#' of the extra checks, such as \code{non121_strategy})
#' and \code{drop_nonorths}.
#'
#' @param genes can be a mixture of any format
#' (HGNC, Ensembl, RefSeq, UniProt, etc.)
#'  and will be automatically converted to
#'   standardised HGNC symbol format.
#' @inheritParams convert_orthologs
#' @inheritParams gprofiler2::gorth
#'
#' @return Ortholog map \code{data.frame} with at
#'  least the columns "input_gene" and "ortholog_gene".
#' @export
#'
#' @examples
#' data("exp_mouse")
#' gene_map <- map_orthologs(
#'     genes = rownames(exp_mouse),
#'     input_species = "mouse"
#' )
map_orthologs <- function(genes,
                          standardise_genes = FALSE,
                          input_species,
                          output_species = "human",
                          method = c("gprofiler", "homologene"),
                          mthreshold = Inf,
                          verbose = TRUE,
                          ...) {
    
    method <- tolower(method)[1]
    messager("Converting", input_species, "==>", output_species,
        "orthologs using:", method,
        v = verbose
    )
    #### Standardise gene names first ####
    if (standardise_genes) {
        messager("Standardising gene names first.", v = verbose)
        syn_map <- map_genes(
            genes = genes,
            species = input_species,
            drop_na = TRUE,
            verbose = verbose
        )
        genes <- syn_map$name
    }
    #### Select mapping method ####
    # Both methods will return a dataframe with at least the columns
    # "input_gene" and "ortholog_gene"
    #### gprofiler ####
    if (methods_opts(method = method, gprofiler_opts = TRUE)) {
        gene_map <- map_orthologs_gprofiler(
            genes = genes,
            input_species = input_species,
            output_species = output_species,
            mthreshold = mthreshold,
            verbose = verbose,
            ...
        )
    }
    #### homologene ####
    if (methods_opts(method = method, homologene_opts = TRUE)) {
        gene_map <- map_orthologs_homologene(
            genes = genes,
            input_species = input_species,
            output_species = output_species,
            verbose = verbose,
            ...
        )
    }
    #### babelgene ####
    if (methods_opts(method = method, babelgene_opts = TRUE)) {
        gene_map <- map_orthologs_babelgene(
            genes = genes,
            input_species = input_species,
            output_species = output_species,
            verbose = verbose,
            ...
        )
    }
    #### Add back in original gene names ####
    if (standardise_genes && exists("syn_map")) {
        gene_map <- add_synonyms(
            gene_map = gene_map,
            syn_map = syn_map
        )
    }
    return(gene_map)
}
