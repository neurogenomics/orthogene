#' Aggregate rows: monocle3
#' 
#' @param x Input matrix.
#' @param groupings Gene groups of the same length as \code{nrow(X)}.
#' @param form Formula.
#' @param fun Aggregation function.
#' @param na.action Na action.
#' @returns Aggregated matrix.
#' 
#' @keywords internal
#' @importFrom methods is
#' @importFrom Matrix Matrix t
#' @importFrom stats as.formula
#' @source 
#' \code{ 
#' x <- Matrix::rsparsematrix(nrow = 1000, ncol = 2000, density = .10)
#' groupings <- rep(c("A","B"),nrow(X)/2)
#' X2 <- orthogene:::aggregate_rows_monocle3(x = x, groupings=groupings)
#' }
aggregate_rows_monocle3 <- function(x,
                                    groupings = NULL,
                                    form = NULL,
                                    fun = "sum",
                                    na.action = stats::na.omit) {
    if (!methods::is(x, "Matrix")) {
        x <- Matrix::Matrix(as.matrix(x), sparse = TRUE)
    }
    if (fun == "count") {
        x <- x != 0
    }
    groupings2 <- data.frame(A = as.factor(groupings))
    if (is.null(form)) {
        form <- stats::as.formula("~0+.")
    }
    form <- stats::as.formula(form)
    mapping <- dMcast(data = groupings2, 
                      formula = form, 
                      na.action = na.action)
    colnames(mapping) <- substring(colnames(mapping), 2)
    ### This step throws an error when gene mappings are 1:many or many:many.
    result <- Matrix::t(mapping) %*% x
    if (fun == "mean") {
        result <- result / as.numeric(table(groupings)[rownames(result)])
    }
    attr(result, "crosswalk") <- extract(groupings, match(
        rownames(result),
        groupings2$A
    ))
    return(result)
}
