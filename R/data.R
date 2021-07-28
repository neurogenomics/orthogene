#' Gene expression data: mouse 
#' 
#' Mean pseudobulk single-cell RNA-seq gene expression matrix.
#' 
#' Data originally comes from Zeisel et al., 2018 (Cell).
#' 
#' @source \href{https://pubmed.ncbi.nlm.nih.gov/30096314/}{Publication}
#' \code{
#' ctd <- ewceData::ctd()
#' exp_mouse <- as(ctd[[1]]$mean_exp, "sparseMatrix")
#' usethis::use_data(exp_mouse, overwrite = TRUE)
#' }
#' @format sparse matrix
#' @usage data("exp_mouse")
"exp_mouse"
 