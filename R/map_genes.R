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
#' @inheritParams gprofiler2::gconvert
#' 
#' @return Table with standardised genes. 
#' @export 
#' @importFrom gprofiler2 gconvert
#' @importFrom stats na.omit
#' 
#' @examples 
#' data("exp_mouse")
#' genes <-  c("Klf4", "Sox2", "TSPAN12","NM_173007","Q8BKT6",
#'             "ENSMUSG00000012396","ENSMUSG00000074637")
#' mapped_genes <- map_genes(genes=genes,
#'                           species="mouse")
map_genes <- function(genes,
                      species="hsapiens", 
                      target = "ENSG",
                      mthreshold=Inf,
                      drop_na=FALSE,
                      numeric_ns="",
                      verbose=TRUE){ 
  organism <- map_species(species = species, 
                          verbose = verbose)
  syn_map <- gprofiler2::gconvert(query = genes,
                                  organism = organism,
                                  target = target,
                                  mthreshold = mthreshold,
                                  filter_na = drop_na,
                                  numeric_ns = numeric_ns) 
  if(drop_na){
    syn_map <- remove_all_nas(dat = syn_map, 
                              col_name = "name",
                              verbose = verbose)
  }
  
  n_genes <- length(genes);
  n_mapped <- length(stats::na.omit(syn_map$name));
  messager(formatC(n_genes, big.mark = ","),"/",formatC(n_mapped,big.mark = ","),
           paste0("(",round(n_mapped/n_genes*100,digits = 2),"%)"),
           "genes mapped.",v=verbose)
  return(syn_map)
}
