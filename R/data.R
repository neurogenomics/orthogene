#' Gene expression data
#' 
#' Single-cell RNA-seq gene expression matrix \code{"exp"} and 
#' associated per-cell metadata \code{"annot"} from mouse brain.
#' 
#' Data originally comes from Zeisel et al., 2015 (Science).
#' 
#' @source \href{https://pubmed.ncbi.nlm.nih.gov/25700174/}{Publication}
#' @examples 
#' \dontrun{
#' cortex_mrna <- ewceData::cortex_mrna()
#' usethis::use_data(cortex_mrna, overwrite = TRUE)
#' }
"cortex_mrna"