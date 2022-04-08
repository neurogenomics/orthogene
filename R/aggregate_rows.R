#' Aggregate rows of matrix
#'
#' Aggregate rows of a matrix using a grouping vector.
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
aggregate_rows <- function(X,
                           groupings,
                           FUN = "sum",
                           method = c("monocle3", "stats"),
                           as_sparse = TRUE,
                           as_DelayedArray = TRUE,
                           dropNA = TRUE,
                           verbose = TRUE) {
    messager("Aggregating rows using:", method[1], v = verbose)
    #### Find NA genes ####
    na_genes <- find_all_nas(v = groupings)
    groupings[na_genes] <- NA

    if (tolower(method[1]) == "stats") {
        X_agg <- aggregate_rows_stats(
            X = X,
            groupings = groupings,
            FUN = FUN,
            dropNA = dropNA
        )
    } else if (tolower(method[1]) == "monocle3") {
        X_agg <- aggregate_rows_monocle3(
            x = X,
            groupings = groupings,
            fun = FUN,
            na.action = if (dropNA) {
                stats::na.omit
            } else {
                stats::na.pass
            }
        )
    } else {
        method_opts <- eval(formals(orthogene:::aggregate_rows)$method)
        stop_msg <- c(
            "method must be one of:\n",
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
        X_agg <- methods::as(X_agg, "sparseMatrix")
    }
    if (as_DelayedArray) {
        X_agg <- DelayedArray::DelayedArray(X_agg)
    }
    return(X_agg)
}
