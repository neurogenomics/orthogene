aggregate_rows_monocle3 <- function(x,
                                    groupings=NULL,
                                    form=NULL, 
                                    fun="sum", 
                                    ...){

  if (!methods::is(x, "Matrix")) 
    x <- Matrix::Matrix(as.matrix(x), sparse = TRUE)
  if (fun == "count") 
    x <- x != 0
  groupings2 <- data.frame(A = as.factor(groupings))
  if (is.null(form)) 
    form <- stats::as.formula("~0+.")
  form <- stats::as.formula(form)
  mapping <- Matrix.utils::dMcast(groupings2, form)
  colnames(mapping) <- substring(colnames(mapping), 2)
  result <- Matrix::t(mapping) %*% x
  if (fun == "mean") 
    result <- result/as.numeric(table(groupings)[rownames(result)])
  attr(result, "crosswalk") <- grr::extract(groupings, match(rownames(result), 
                                                             groupings2$A))
  return(result)
}
