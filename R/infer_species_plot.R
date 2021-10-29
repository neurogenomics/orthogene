#' infer_species_plot
#' 
#' Plot results from \link[orthogene]{infer_species_plot}.
#' 
#' @return ggplot object.
#' 
#' @keywords internal
#' @importFrom utils installed.packages
infer_species_plot <- function(matches,
                               show_plot = TRUE){
    percent_match <- NULL
    
    #### Resolves the issue described here ####
    # https://stackoverflow.com/a/66423481/13214824
    if("hrbrthemes" %in% rownames(utils::installed.packages())){
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