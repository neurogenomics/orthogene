check_gene_map <- function(gene_map,
                           input_col,
                           output_col){
    if (!input_col %in% colnames(gene_map)) {
        stop_msg <- paste(paste0("input_col=",paste0("'",input_col,"'")),
                          "not in gene_map column names.")
        stop(stop_msg)
    }     
    if (!output_col %in% colnames(gene_map)) {
        stop_msg2 <- paste(paste0("output_col=",paste0("'",output_col,"'")),
                           "not in gene_map column names.")
        stop(stop_msg2)
    }  
}