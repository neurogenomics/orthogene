#' Ensembl IDs -> Gene symbols
#'
#' Convert HGNC gene symbols to Ensembl IDs.
#'
#' @param gene_symbols List of HGNC gene symbols.
#' @return List of ensembl IDs.
#' @examples 
#' gene_symbols <- c("FOXP2","BDNF","DCX","GFAP")
#' ensembl_IDs <- hgnc_to_ensembl(gene_symbols)
#' @importFrom AnnotationDbi mapIds
#' @importFrom EnsDb.Hsapiens.v75 EnsDb.Hsapiens.v75
#' @export
hgnc_to_ensembl <- function(gene_symbols){
  gene_symbols[is.na(gene_symbols)] <- "NA"
  conversion <- AnnotationDbi::mapIds(EnsDb.Hsapiens.v75::EnsDb.Hsapiens.v75,
                                      keys = gene_symbols,
                                      keytype = "SYMBOL",
                                      column = "GENEID")
  return(conversion)
}