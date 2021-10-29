#' infer_species_plot
#' 
#' Plot results from \link[orthogene]{infer_species}.
#' 
#' @return ggplot object.
#' 
#' @keywords internal
#' @importFrom utils installed.packages install.packages
infer_species_plot <- function(matches,
                               show_plot = TRUE){
    percent_match <- NULL
    
    #### Resolves the issue described here ####
    # https://stackoverflow.com/a/66423481/13214824
    # Solution:
    ## https://gi th ub.com/hrbrmstr/hrbrthemes/issues/56#issuecomment-689857655
    if(Sys.info()["sysname"] == "Darwin"){
        requireNamespace("knitr")
        knitr::opts_chunk$set(dev=c('png', 'cairo_pdf'),
                              comment="", 
                              echo=TRUE,
                              warning=FALSE, 
                              cache=FALSE,
                              message=FALSE) 
    }
    if(requireNamespace("hrbrthemes")){
        hrbrthemes::import_roboto_condensed()    
    } 
    #### Plot ####
    gg <- ggplot(matches, aes(y=species, 
                              x=percent_match, 
                              fill=percent_match, 
                              label=paste0(percent_match,"%"))) +
        geom_col(position = "identity") +
        geom_label(color="white") + 
        theme_bw() +
        scale_fill_gradient(low = "black", high = "purple")
    if(show_plot) print(gg)
    return(gg)        
}