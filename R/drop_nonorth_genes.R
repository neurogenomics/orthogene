drop_nonorth_genes <- function(gene_map,
                               output_species="output_species",
                               verbose=TRUE){
  messager("Checking for genes without orthologs in",
           paste0(output_species,"."),v=verbose)
  #### Drop NAs of all kinds: input_gene ####
  gene_map <- remove_all_nas(dat = gene_map, 
                             col_name = "input_gene",
                             verbose = verbose) 
  #### Drop NAs of all kinds: ortholog_gene ####
  gene_map <- remove_all_nas(dat = gene_map, 
                             col_name = "ortholog_gene",
                             verbose = verbose) 
  return(gene_map)
}