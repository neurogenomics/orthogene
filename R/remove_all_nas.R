remove_all_nas <- function(dat,
                           col_name,
                           verbose=TRUE){
  genes <- extract_gene_list(gene_df = dat,
                             gene_input = col_name)
  all_nas <- find_all_nas(v=genes) 
  if(sum(all_nas)>0){
    messager("Dropping",formatC(sum(all_nas),big.mark = ","),
             "NAs of all kinds from",paste0(col_name,"."),
             v=verbose)
    dat <- dat[!all_nas,]
  }   
  return(dat)
}