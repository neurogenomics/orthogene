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
#' @inheritParams aggregate_mapped_genes
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
#'     input_species = "mouse")
map_orthologs <- function(genes,
                          standardise_genes = FALSE,
                          input_species,
                          output_species = "human",
                          method = c("gprofiler",
                                     "homologene",
                                     "babelgene"),
                          mthreshold = Inf,
                          #### Used only when gene_map supplied ####
                          gene_map = NULL,
                          input_col = "input_gene",
                          output_col = "ortholog_gene",
                          verbose = TRUE,
                          ...) {
    
    method <- tolower(method)[1]
    if(!is.null(gene_map)){
        method <- "user-supplied gene_map"
    }
    messager("Converting", input_species, "==>", output_species,
             "orthologs using:", method, v = verbose)
    #### Standardise gene names first ####
    if (isTRUE(standardise_genes)) {
        messager("Standardising gene names first.", v = verbose)
        syn_map <- map_genes(
            genes = genes,
            species = input_species,
            drop_na = TRUE,
            verbose = verbose
        )
        genes <- syn_map$name
    }
    
    #deal with case where no genes found for species
    if(!is.null(genes)){
      #### Select mapping method ####
      #### User-supplied mapping ####
      if(!is.null(gene_map)){ 
          gene_map <- map_orthologs_custom(gene_map = gene_map,
                                           input_species = input_species,
                                           output_species = output_species, 
                                           input_col = input_col,
                                           output_col = output_col, 
                                           verbose = verbose)
      } else if (methods_opts(method = method, gprofiler_opts = TRUE)) {
          # Both methods will return a dataframe with at least the columns
          # "input_gene" and "ortholog_gene"
          #### gprofiler ####
          gene_map <- map_orthologs_gprofiler(
              genes = genes,
              input_species = input_species,
              output_species = output_species,
              mthreshold = mthreshold,
              verbose = verbose,
              ...
          )
      } else if (methods_opts(method = method, homologene_opts = TRUE)) {
          #### homologene ####
          gene_map <- map_orthologs_homologene(
              genes = genes,
              input_species = input_species,
              output_species = output_species,
              verbose = verbose,
              ...
          )
      } else if (methods_opts(method = method, babelgene_opts = TRUE)) {
          #### babelgene ####
          gene_map <- map_orthologs_babelgene(
              genes = genes,
              input_species = input_species,
              output_species = output_species,
              verbose = verbose,
              ...
          )
      } else {
          stop(paste0("method='", method, "' not recognised."),
                   "Must be one of:\n ",
                   paste("-", c(
                       paste(methods_opts(gprofiler_opts = TRUE), collapse = " | "),
                       paste(methods_opts(homologene_opts  = TRUE), collapse = " | "),
                       paste(methods_opts(babelgene_opts = TRUE), collapse = " | ")
                   ),  collapse = "\n "))
           
      }
    }
    #### Check is already in the same species ####
    if(isFALSE(standardise_genes) &&
       is.null(gene_map)){
        messager("input_species already formatted as output species.",
                 "Returning input data directly.",v=verbose)
        return(NULL)
    }
    #### Add back in original gene names ####
    if (isTRUE(standardise_genes) && exists("syn_map")) {
        gene_map <- add_synonyms(
            gene_map = gene_map,
            syn_map = syn_map
        )
    }
    return(gene_map)
}
