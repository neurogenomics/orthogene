transpose_any <- function(X,
                          verbose=TRUE){
  #### Handles all situations ###
  Xt <- Matrix::t(X)
  # if(methods::is(X,"sparseMatrix")){
  #   messager("Transposing sparseMatrix.",v=verbose)
  #   Xt <- SparseM::t(X)
  # }
  # if(methods::is(X,"matrix") | methods::is(X,"Matrix")){
  #   messager("Transposing matrix.",v=verbose)
  #   Xt <- t(X)
  # } else {
  #   messager("Transposing",paste0(methods::is(X)[1],"."),v=verbose)
  #   Xt <- t(X)
  # }
  return(Xt)
}