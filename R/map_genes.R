#' Map genes
#' 
#' Input a list of genes in any format 
#' (e.g. HGNC symbols, ENSEMBL IDs, UCSC) and return
#' a table with standardised gene symbols
#'  (the "names" column). 
#' 
#' Uses \code{gprofiler2::gconvert()}. 
#' The exact contents of the output table will depend on 
#' \code{target} parameter. 
#' See \code{?gprofiler2::gconvert} for more details. 
#' 
#' @param genes Gene list.
#' @param species Species to map against. 
#' @param verbose Print messages. 
#' @inheritParams gprofiler2::gconvert
#' 
#' @return Table with standardised genes. 
#' @export 
#' @importFrom gprofiler2 gconvert
#' @importFrom stats na.omit
#' 
#' @examples 
#' data("exp_mouse")
#' mapped_genes <- map_genes(genes=rownames(exp_mouse)[seq(1,100)],
#'                           species="mouse")
map_genes <- function(genes,
                      species="hsapiens", 
                      target = "ENSG",
                      mthreshold=Inf,
                      filter_na=FALSE,
                      numeric_ns="",
                      verbose=TRUE){ 
  organism <- map_species(species = species, 
                          verbose = verbose)
  syn_map <- gprofiler2::gconvert(query = genes,
                                  organism = organism,
                                  target = target,
                                  mthreshold = mthreshold,
                                  filter_na = filter_na,
                                  numeric_ns = numeric_ns) 
  n_genes <- length(genes);
  n_mapped <- length(stats::na.omit(syn_map$name));
  messager(formatC(n_genes, big.mark = ","),"/",formatC(n_mapped,big.mark = ","),
           paste0("(",round(n_mapped/n_genes*100,digits = 2),"%)"),
           "genes mapped.",v=verbose)
  return(syn_map)
}
