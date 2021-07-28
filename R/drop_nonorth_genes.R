drop_nonorth_genes <- function(gene_df,
                               output_species="output_species",
                               verbose=TRUE){
  messager("+ Dropping genes without orthologs in",output_species,v=verbose)
  gene_df <- gene_df[!is.na(gene_df$Gene),]
  gene_df <- gene_df[gene_df$Gene!="NA_character_",]
  return(gene_df)
}