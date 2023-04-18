#' Map orthologs: gprofiler
#'
#' Map orthologs from one species to another
#' using a custom \code{gene_map} table.  
#' @inheritParams aggregate_mapped_genes
#'
#' @return Ortholog map \code{data.frame} 
#' @keywords internal
map_orthologs_custom <- function(gene_map,
                                 input_species,
                                 output_species, 
                                 input_col,
                                 output_col,
                                 verbose = TRUE) {   
    gene_map <- data.table::as.data.table(gene_map)
    #### Check input_col/output_col ####
    check_gene_map(gene_map = gene_map, 
                   input_col = input_col,
                   output_col = output_col)
    data.table::setnames(gene_map,
                         c(input_col,output_col),
                         c("input_gene","ortholog_gene"))
    return(gene_map)
}
