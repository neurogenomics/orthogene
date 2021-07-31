report_gene_map <- function(gene_df2,
                            n_input_genes,
                            verbose=TRUE){
  n_dropped <- n_input_genes - nrow(gene_df2)
  messager("\n=========== REPORT SUMMARY ===========\n")
  messager("Total genes dropped during inter-species conversion: ",
           formatC(n_dropped,big.mark=","),"/",
           formatC(n_input_genes,big.mark=","),
           paste0("(",format(n_dropped/n_input_genes*100, digits = 2),"%)"),
           v=verbose)
}