
#' Map orthologs
#' 
#' Map orthologs from one species to another.
#' 
#' @inheritParams convert_orthologs
#' 
#' @export
#' @importFrom dplyr rename
#' @examples 
#' data("cortex_mrna")
#' gene_df <- data.frame(Gene=rownames(cortex_mrna$exp))
#' gene_map <- map_orthologs(gene_df=gene_df,  gene_col="Gene", input_species="mouse")
map_orthologs <- function(gene_df,
                          gene_col,
                          input_species,
                          output_species="human",
                          verbose=TRUE){
  messager("+ Searching for orthologs.",v=verbose)
  taxaID <- taxa_id_dict(species=input_species)
  taxaID_out <- taxa_id_dict(species=output_species)
  input_genes <- gene_df[[gene_col]]
  orths <- homologene::homologene(genes = input_genes,
                                  inTax = unname(taxaID),
                                  outTax = taxaID_out)
  orths <- orths[orths[,1] %in% input_genes,]
  orths_key <- setNames(orths[,2], orths[,1])
  gene_df <- dplyr::rename(gene_df, Gene_orig=all_of(gene_col))
  gene_df$Gene <- orths_key[input_genes]
  return(gene_df)
}