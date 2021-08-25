#' Gene expression data: mouse
#'
#' @description
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


#' Transcript expression data: mouse
#'
#' @description
#' Mean pseudobulk single-cell RNA-seq Transcript expression matrix.
#'
#' Data originally comes from Zeisel et al., 2018 (Cell).
#'
#' @source \href{https://pubmed.ncbi.nlm.nih.gov/30096314/}{Publication}
#' \code{
#' data("exp_mouse")
#' mapped_genes <- map_genes(genes = rownames(exp_mouse)[seq(1,100)],
#'                           target = "ENST",
#'                           species = "mouse",
#'                           drop_na = FALSE)
#' exp_mouse_enst <- exp_mouse[mapped_genes$input,]
#' rownames(exp_mouse_enst) <- mapped_genes$target
#' all_nas <- orthogene:::find_all_nas(rownames(exp_mouse_enst))
#' exp_mouse_enst <- exp_mouse_enst[!all_nas,]
#' exp_mouse_enst <- phenomix::add_noise(exp_mouse_enst)
#' usethis::use_data(exp_mouse_enst, overwrite = TRUE)
#' }
#' @format sparse matrix
#' @usage data("exp_mouse_enst")
"exp_mouse_enst"







#' Reference organisms
#'
#' @description
#' Organism for which gene references are available via
#' \href{https://biit.cs.ut.ee/gprofiler/gost}{gProfiler}
#' \href{https://biit.cs.ut.ee/gprofiler/api/util/organisms_list}{API}.
#'
#' Used as a backup if API is not available.
#'
#' @source \href{https://biit.cs.ut.ee/gprofiler/gost}{gProfiler site}
#' @format \code{data.frame}
#' \code{
#'  URL <- 'https://biit.cs.ut.ee/gprofiler/api/util/organisms_list'
#'  gprofiler_orgs <- jsonlite::fromJSON(URL)
#'  gprofiler_orgs <-  dplyr::arrange(gprofiler_orgs, scientific_name)
#'  usethis::use_data(gprofiler_orgs, overwrite = TRUE, internal=TRUE)
#' }
"gprofiler_orgs"
