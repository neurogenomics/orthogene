
#' Gene symbols -> Ensembl IDs
#'
#' Convert Ensembl IDs to HGNC gene symbols.
#'
#' @param ensembl_ids List of ensembl IDs.
#' @return List of HGNC gene symbols.
#' @examples 
#' ensembl_IDs <- c("ENSG00000128573","ENSG00000176697","ENSG00000077279","ENSG00000131095" )
#' gene_symbols <- ensembl_to_hgnc(ensembl_IDs)
#' @importFrom AnnotationDbi mapIds
#' @importFrom EnsDb.Hsapiens.v75 EnsDb.Hsapiens.v75
#' @export
ensembl_to_hgnc <- function(ensembl_ids){
    ensembl_ids <- gsub("\\..*","",ensembl_ids) # Remove transcript suffixes
    ensembl_ids[is.na(ensembl_ids)] <- "NA"
    conversion <- AnnotationDbi::mapIds(EnsDb.Hsapiens.v75::EnsDb.Hsapiens.v75,
                                        keys = ensembl_ids,
                                        keytype = "GENEID",
                                        column = "SYMBOL")
    return(conversion)
} 



