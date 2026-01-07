#' Get cache save path
#' 
#' Create a save path for a cached file. 
#' 
#' @param fn Function name.
#' @param species input species name.
#' @param method Method (gprofiler2, homologene, or babelgene).
#' @param suffix Cache file suffix.
#' @param save_dir Cache file directory.
#'
#' @return Path string 
#' @keywords internal
get_cache_save_path <- function(fn,
                                 species,
                                 method,
                                 suffix=".csv.gz",
                                 save_dir = cache_dir()
){
    ### Get save_path ###
    if (!is.null(save_dir)){
        save_path <- file.path(
            save_dir, 
            paste0(
                fn,"-",
                tolower(gsub("\\s+","_",species)),"-",
                method,
                suffix
            )
        )  
        return(save_path)
    } 
}
