drop_nonorth_genes <- function(gene_map,
                               output_species="output_species",
                               verbose=TRUE){
  messager("Checking for genes without orthologs in",
           paste0(output_species,"."),v=verbose)
  #### Check for NAs or different kinds ####
  non_orths <- (is.na(unname(gene_map$ortholog_gene))) | 
    (is.nan(unname(gene_map$ortholog_gen))) | 
    (unname(gene_map$ortholog_gene)=="NA_character_")
  if(sum(non_orths)>0){
    messager("+ Dropping",formatC(sum(non_orths),big.mark = ","),
             "non-orthologs.",v=verbose)
    gene_map <- gene_map[!non_orths,] 
  } 
  return(gene_map)
}