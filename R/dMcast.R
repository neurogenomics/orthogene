#' dMcast
#' 
#' Reimplementation of function that originally part of the R package
#' \code{Matrix.utils} before the package was 
#' \href{https://cran.r-project.org/web/packages/Matrix.utils/index.html}{
#' deprecated}. The only difference is that this version of \code{dMcast} does
#' not include an aggregation feature at the end.
#' @param data A \link[base]{data.frame}.
#' @param formula Casting \link[stats]{formula}, 
#' see details for specifics.
#' @param fun.aggregate Name of aggregation function. Defaults to 'sum'.
#' @param value.var Name of column that stores values to be aggregated numerics.
#' @param as.factors If \code{TRUE}, treat all columns as factors, including
#' @param factor.nas If \code{TRUE}, treat factors with NAs as new levels. 
#'  Otherwise, rows with NAs will receive zeroes in all columns for that factor.
#' @param drop.unused.levels Should factors have unused levels dropped?
#'  Defaults to \code{TRUE}, in contrast to \code{model.matrix}
#' @keywords internal
#' @importFrom stats terms as.formula contrasts
#' @importFrom Matrix sparse.model.matrix
#' @source 
#' \code{ 
#' groupings <- data.frame(A = as.factor(sample(1e4,1e6,TRUE)))
#' formula <- stats::as.formula("~0+.")
#' dm <- orthogene:::dMcast(data = groupings, formula = formula)
#' }
dMcast <- function(data,
                   formula, 
                   fun.aggregate = "sum", 
                   value.var = NULL, 
                   as.factors = FALSE, 
                   factor.nas = TRUE, 
                   drop.unused.levels = TRUE) {
    
    values <- 1
    if (!is.null(value.var)) 
        values <- data[, value.var]
    alltms <- stats::terms(formula, data = data)
    # response <- rownames(attr(alltms, "factors"))[
    #     attr(alltms, "response")
    # ]
    tm <- attr(alltms, "term.labels")
    interactionsIndex <- grep(":", tm)
    interactions <- tm[interactionsIndex]
    simple <- setdiff(tm, interactions)
    i2 <- strsplit(interactions, ":")
    newterms <- unlist(
        lapply(i2, 
               function(x) {
                   paste("paste(", 
                         paste(x, collapse = ","), ",", "sep='_'", ")")
               }))
    newterms <- c(simple, newterms)
    newformula <- stats::as.formula(
        paste("~0+", paste(newterms, collapse = "+"))
    )
    allvars <- all.vars(alltms)
    data <- data[, c(allvars), drop = FALSE]
    if (as.factors) 
        data <- data.frame(lapply(data, as.factor))
    characters <- unlist(lapply(data, is.character))
    data[, characters] <- lapply(data[, characters, drop = FALSE], 
                                 as.factor)
    factors <- unlist(lapply(data, is.factor))
    data[, factors] <- lapply(
        data[, factors, drop = FALSE], 
          function(x) {
              if (factor.nas) 
                  if (any(is.na(x))) {
                      levels(x) <- c(levels(x), "NA")
                      x[is.na(x)] <- "NA"
                  }
              if (drop.unused.levels) 
                  if (nlevels(x) != length(na.omit(unique(x)))) 
                      x <- factor(as.character(x))
              y <- stats::contrasts(x, contrasts = FALSE, sparse = TRUE)
              attr(x, "contrasts") <- y
              return(x)
          })
    attr(data, "na.action") <- na.pass
    result <- Matrix::sparse.model.matrix(
        newformula, 
        data,
        drop.unused.levels = FALSE, 
        row.names = FALSE)
    brokenNames <- grep("paste(", colnames(result), fixed = TRUE)
    colnames(result)[brokenNames] <- lapply(
        colnames(result)[brokenNames], 
    function(x) {
        x <- gsub("paste(", replacement = "", x = x, fixed = TRUE)
        x <- gsub(pattern = ", ", replacement = "_", x = x, 
                  fixed = TRUE)
        x <- gsub(pattern = "_sep = \"_\")", replacement = "", 
                  x = x, fixed = TRUE)
        return(x)
    })
    result <- result * values
    # if (isTRUE(response > 0)) {
    #     responses = all.vars(
    #         stats::terms(
    #             stats::as.formula(paste(response,"~0"))
    #         )
    #     )
    #     result <- aggregate.Matrix(result, 
    #                                data[, responses, drop = FALSE],
    #                                fun = fun.aggregate)
    # }
    return(result)
} 
