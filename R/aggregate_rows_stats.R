aggregate_rows_stats <- function(X,
                                 groupings,
                                 FUN = "sum",
                                 dropNA = TRUE) {
    X_agg <- stats::aggregate(
        x = as.matrix(X),
        by = list(groupings),
        FUN = FUN,
        drop = dropNA
    )
    rownames(X_agg) <- X_agg[, 1]
    X_agg <- X_agg[, -1]
    return(X_agg)
}
