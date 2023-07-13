sort_rows_func <- function(gene_df,
                           verbose = TRUE) {
    
    if(is.vector(gene_df)){
        messager("Sorting vector values alphanumerically.", v = verbose)
        gene_df <- sort(gene_df)
    } else {
        messager("Sorting rownames alphanumerically.", v = verbose)
        gene_df <- gene_df[sort(rownames(gene_df)), ]   
    } 
    return(gene_df)
}
