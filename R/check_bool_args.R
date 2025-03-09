#' Check boolean args
#'
#' Check that boolean args are indeed boolean
#'
#' @inheritParams convert_orthologs
#' 
#' @keywords internal
check_bool_args <- function(standardise_genes,
                            drop_nonorths,
                            as_sparse,
                            as_DelayedArray,
                            sort_rows){
    if (!is.logical(standardise_genes)) {
        stop("standardise_genes must be a boolean.")
    }
    if (!is.logical(drop_nonorths)) {
        stop("drop_nonorths must be a boolean.")
    }
    if (!is.logical(as_sparse)) {
        stop("as_sparse must be a boolean.")
    }
    if (!is.logical(as_DelayedArray)) {
        stop("as_DelayedArray must be a boolean.")
    }
    if (!is.logical(sort_rows)) {
        stop("sort_rows must be a boolean.")
    }
    
}