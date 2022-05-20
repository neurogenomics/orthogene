#' Aggregate rows of matrix
#'
#' Aggregate rows of a matrix for many:1 mappings,  using a grouping vector.
#'
#' @param X Input matrix.
#' @param groupings Gene groups of the same length as \code{nrow(X)}.
#'
#' @inheritParams aggregate_mapped_genes
#'
#' @return Aggregated matrix
#'
#' @keywords internal
#' @importFrom methods is
#' @source 
#' \code{
#' data("exp_mouse_enst")
#' X <- exp_mouse_enst
#' gene_map <- map_genes(genes = rownames(X),species = "mouse")
#' X_agg <- orthogene:::aggregate_rows(X = X, 
#'                                     groupings = gene_map$name)
#' sum(duplicated(rownames(exp_mouse))) # 0 
#' sum(duplicated(rownames(X))) # 1215 
#' sum(duplicated(rownames(X_agg))) # 0 
#' }
aggregate_rows <- function(X,
                           groupings,
                           agg_fun = "sum",
                           agg_method = c("monocle3", "stats"),
                           as_sparse = TRUE,
                           as_DelayedArray = TRUE,
                           dropNA = TRUE,
                           verbose = TRUE) {
    agg_method <- tolower(agg_method[1])
    messager("Aggregating rows using:", agg_method, v = verbose) 
    #### Find NA genes ####
    na_genes <- find_all_nas(v = groupings)
    groupings[na_genes] <- NA

    if (agg_method == "stats") {
        X_agg <- aggregate_rows_stats(
            X = X,
            groupings = groupings,
            FUN = agg_fun,
            dropNA = dropNA
        )
    } else if (agg_method == "monocle3") {
        X_agg <- aggregate_rows_monocle3(
            x = X,
            groupings = groupings,
            fun = agg_fun,
            na.action = if (dropNA) {
                stats::na.omit
            } else {
                stats::na.pass
            }
        )
    } else {
        method_opts <- eval(formals(aggregate_rows)$agg_method)
        stop_msg <- c(
            "agg_method must be one of:\n",
            paste("  -", method_opts, collapse = "\n")
        )
        stop(stop_msg)
    } 
    #### Remove NA ####
    X_agg <- X_agg[(rownames(X_agg) != "NA") & (!is.na(rownames(X_agg))), ]

    #### Change matrix class ####
    if (!any(methods::is(X_agg, "matrix"), methods::is(X_agg, "Matrix"))) {
        X_agg <- as.matrix(X_agg)
    }
    if (as_sparse) {
        X_agg <- to_sparse(X_agg)
    }
    if (as_DelayedArray) {
        X_agg <- as_delayed_array(X_agg, 
                                  as_DelayedArray=as_DelayedArray,
                                  verbose=verbose)
    }
    return(X_agg)
}
