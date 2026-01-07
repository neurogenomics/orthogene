#' Get cache save dir
#' 
#' Create a package-specific cache dir. 
#'
#' @return Path string
#' @importFrom tools R_user_dir 
#' @keywords internal
cache_dir <- function(){
    p <- tools::R_user_dir("orthogene",
                          which="cache")
    dir.create(p, showWarnings=FALSE, recursive=TRUE)
    return(p)
}