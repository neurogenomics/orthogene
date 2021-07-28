#' Convert genes from one species to another
#' 
#' Maps genes across species and then converts them to the \code{ouput_species}.
#' 
#' @param obj Data object to be converted. 
#' Can be a matrix, data.frame, data.table. 
#' @param convert_orths Convert row names to \code{output_species} orthologs. 
#' @param as_sparse If \code{obj} is a matrix, 
#' it can be converted to a sparse matrix. 
#' @param sort_rows Sort rows alphanumerically.
#' @inheritParams convert_orthologs 
#' 
#' @return Matrix with converted gene names as rows. 
#' @export
#' @importFrom methods is as
#' 
#' @examples
#' data("exp_mouse")
#' exp_human <- map_matrix(obj=exp_mouse, input_species="mouse")
map_matrix <- function(obj, 
                       input_species, 
                       output_species="human", 
                       drop_nonorths=TRUE, 
                       one_to_one_only=TRUE, 
                       convert_orths=TRUE,  
                       as_sparse=FALSE, 
                       sort_rows=FALSE, 
                       verbose=TRUE){  
   if( is(obj,"matrix") | is(obj,"Matrix") |  is(obj,"data.frame") | is(obj,"data.table")){
     rowDat <- data.frame(gene=rownames(obj), check.names = FALSE)
   }  
    
    orths <- convert_orthologs(gene_df=rowDat,
                               gene_col="gene",
                               input_species=input_species,
                               output_species=output_species,
                               drop_nonorths=drop_nonorths,
                               one_to_one_only=one_to_one_only,
                               genes_as_rownames=TRUE,
                               verbose=verbose)
    # Not always sure about how the exp has been named (original species gene names or human orthologs)
    obj <- tryCatch({obj[orths$Gene_orig,]},
                    error=function(e){ obj[orths$Gene,]
                    })
    if(convert_orths) rownames(obj) <- orths$Gene 
    
    if(as_sparse){
      messager("Converting obj to sparseMatrix.",v=verbose)
      obj <- methods::as(obj, "sparseMatrix")
    }
    
    if(sort_rows){
      messager("Sorting rownames alphanumerically.",v=verbose)
      obj <- obj[sort(rownames(obj)),]
    }
    return(obj)
}
