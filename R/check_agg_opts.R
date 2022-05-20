check_agg_opts <- function(func = NULL) {
    funcs <- c("sum", "mean", "median", "min", "max")
    agg_dict <- stats::setNames(funcs, funcs)
    if (is.null(func)) {
        return(agg_dict)
    } else {
        if (func %in% names(agg_dict)) {
            return(agg_dict[func])
        } else {
            stop_msg <- paste0(
                "Aggregation function must be one of:\n",
                paste("  -", agg_dict, collapse = "\n")
            )
            stop(stop_msg)
        }
    }
}
