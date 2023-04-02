use_cache <- function(tree_source,
                      save_dir,
                      verbose=TRUE){
    if(!is.null(save_dir)){
        tree_cache <- file.path(
            save_dir,
            gsub("?download=1","",basename(tree_source),fixed = TRUE))
        if(file.exists(tree_cache)) {
            messager("Importing cached tree.",v=verbose)
            return(tree_cache)
        } else {
            dir.create(dirname(tree_cache),
                       showWarnings = FALSE, 
                       recursive = TRUE)
            utils::download.file(url = tree_source,
                                 destfile = tree_cache)
            return(tree_cache)
        }
    } 
    return(tree_source)
}