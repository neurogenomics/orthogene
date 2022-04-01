aggregate_rows_delayedarray <- function(X,
                                        labels,
                                        as_sparse = TRUE,
                                        as_DelayedArray = TRUE) {
    #### NOTE: ####
    # This method is way to slow currently.
    # Need to improve this and remove the lapply aspect,

    #### Iterate over each gene ####
    agg_list <- lapply(unique(labels), function(g) {
        message(as.character(g))
        grp <- DelayedMatrixStats::colMeans2(
            x = X,
            rows = rownames(X)[labels == g]
        )
        names(grp) <- colnames(X)
        return(grp)
    }) %>% `names<-`(unique(labels))

    #### Reconstruct matrix ####
    mat <- do.call(rbind, agg_list)
    #### Change matrix class ####
    if (as_sparse) {
        mat <- methods::as(mat, "sparseMatrix")
    }
    if (as_DelayedArray) {
        mat <- DelayedArray::DelayedArray(mat)
    }
    return(mat)
}
