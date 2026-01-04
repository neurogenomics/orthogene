#' Map genes
#'
#' Input a list of genes, transcripts, proteins, SNPs,
#' or genomic ranges in any format
#' (HGNC, Ensembl, RefSeq, UniProt, etc.) and return
#' a table with standardised gene symbols
#'  (the "names" column).
#'
#' Uses \link[gprofiler2]{gconvert}.
#' The exact contents of the output table will depend on
#' \code{target} parameter.
#' See \code{?gprofiler2::gconvert} for more details.
#'
#' @param genes Gene list.
#' @param species Species to map against.
#' @param drop_na Drop all genes without mappings.
#' Sets \code{gprofiler2::gconvert(filter_na=)} as well
#' an additional round of more comprehensive \code{NA} filtering
#' by \pkg{orthogene}.
#'
#' @param verbose Print messages.
#' @inheritParams all_genes
#' @inheritParams gprofiler2::gconvert
#' 
#'
#' @return Table with standardised genes.
#' @export
#' @importFrom gprofiler2 gconvert
#' @importFrom stats na.omit
#'
#' @examples
#' genes <- c(
#'     "Klf4", "Sox2", "TSPAN12", "NM_173007", "Q8BKT6",
#'     "ENSMUSG00000012396", "ENSMUSG00000074637"
#' )
#' mapped_genes <- map_genes(
#'     genes = genes,
#'     species = "mouse"
#' )
map_genes <- function(genes,
                      species = "hsapiens",
                      target = "ENSG",
                      mthreshold = Inf,
                      drop_na = FALSE,
                      numeric_ns = "",
                      run_map_species = TRUE,
                      verbose = TRUE) {
    
    if(isTRUE(run_map_species)){
        organism <- map_species(
            species = species,
            method = "gprofiler",
            output_format = "id",
            verbose = verbose
        )
    } else {organism <- species} 
    #### Special case: planarians ####
    if(grepl("^scmedi|^schmidtea",organism, ignore.case = TRUE)){
        syn_map <- map_genes_planosphere(genes = genes,  
                                         verbose = verbose)
        
    } else {
    #### All other species ####
        target <- gconvert_target_opts(target = target, 
                                       species = species) 
        syn_map <- gprofiler2::gconvert(
            query = genes,
            ## organism must be in "mmusculus" format
            organism = unname(organism),
            target = target,
            mthreshold = mthreshold,
            filter_na = drop_na,
            numeric_ns = numeric_ns
        )
    }
    #### Drop NAs ####
    # !is.null(syn_map) catches where no hit genes are found in the species
    # otherwise map_genes() will give an error rather than returning NULL
    if (isTRUE(drop_na) && !is.null(syn_map)) {
        syn_map <- remove_all_nas(
            dat = syn_map,
            col_name = "name",
            verbose = verbose
        )
    }
    #### Report ####
    n_genes <- length(genes)
    mapped_genes <- syn_map$target[
        (!is.na(syn_map$input)) & 
        (!is.na(syn_map$name))
    ]
    n_mapped <- length(mapped_genes)
    messager(
        formatC(n_mapped, big.mark = ","), "/",
        formatC(n_genes, big.mark = ","),
        paste0("(", round(n_mapped / n_genes * 100, digits = 2), "%)"),
        "genes mapped.",
        v = verbose
    )
    #### Return ####
    return(syn_map)
}
