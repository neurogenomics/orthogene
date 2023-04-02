#' Plot a phylogenetic tree
#' 
#' Plot a phylogenetic tree with ggtree and metadata from
#'  \link[orthogene]{report_orthologs}.
#' @param tr Tree.
#' @param d Metadata
#' @param scaling_factor How much to scale y-axis parameters (e.g. offset) by.
#' @param clades Clades metadata.
#' @param clades_palette Palette to color highlighted \code{clades} with. 
#' @param verbose Print messages.
#' 
#' @returns \link[ggplot2]{ggplot} object.
#' 
#' @keywords internal
#' @importFrom ggtree %<+% 
ggtree_plot <- function(tr,
                        d,
                        scaling_factor = 1,
                        clades = NULL,
                        clades_palette = NULL,
                        reference_species = NULL, 
                        verbose = TRUE){
    # devoptera::args2vars(ggtree_plot)
    
    requireNamespace("ggtree")
    ## ggimage is required but only listed as a Suggest in ggtree 
    ## for some reason.
    requireNamespace("ggimage") 
    requireNamespace("ggplot2") 
    requireNamespace("magick")
    
    one2one_orthologs <- node <- name <- svg<- label <- 
        reference_percent <- ring_size <- input_species <- 
        tip.label_formatted <- NULL; 
    
    #### Create base plot ####
    messager("Creating ggtree plot.",v=verbose)
    d$ring_size <- 100
    x <- scaling_factor #300   
    p <- ggtree::ggtree(tr = tr,
                size = 1,
                layout = "circular",
                # mrsd = "2020-01-01",
                ggplot2::aes(color=one2one_orthologs), 
                continuous = 'colour') %<+% d  
    if(!is.null(clades)){ 
        #### Clade branch highlights ####
        p <- p +  ggtree::geom_hilight(data = clades, 
                                       to.bottom = TRUE,
                                       ggplot2::aes(node=node,
                                                    fill=name))
    }  
    #### Add the rest ####
    p <- p + 
    #### Internal node dots ####
    ggtree::geom_nodepoint(color="white", alpha=.6, size=3) + 
    #### Internal node labels ####
    # ggtree::geom_nodelab(angle=0, geom = "label") + 
    #### Large filled circle ####
    ggtree::geom_tippoint(ggplot2::aes(size=reference_percent),
                          alpha=.75) + 
    #### Large unfilled ring ####
    ggtree::geom_tippoint(ggplot2::aes(size=ring_size),
                          shape=1, alpha=1, 
                          show.legend = FALSE) +
    #### Small dark dots ####
    ggtree::geom_tippoint(ggplot2::aes(size=1.2), alpha=.6,
                          show.legend = FALSE, color=1) +
    #### Silhouettes ####
    ggtree::geom_tiplab2(ggplot2::aes(image=svg),
             geom="image",
             na.rm=TRUE,
             image_fun=function(.) magick::image_transparent(.,'white'),
             by="width", 
             size=.1,
             offset=.7*x, alpha=.75, angle=0) +
    #### Species name ####
    ggtree::geom_tiplab2(ggplot2::aes(label=tip.label_formatted), 
             geom = "label",
             offset = .3*x,
             vjust = -.5, 
             color="grey20",
             angle = 0,
             align = TRUE,
             alpha = .75) +      
    #### % orthologs label ####
    ggtree::geom_tiplab2(
        ggplot2::aes(label=paste0(round(reference_percent,1),"%")), 
                 geom = "label",
                 offset = .3*x,
                 vjust = .5, 
                 color="grey60",
                 angle = 0,
                 align = TRUE,
                 alpha = .75) +  
    ggplot2::scale_color_viridis_c(
        name=paste("1:1",reference_species,"orthologs (count)")) +
    ggplot2::scale_fill_brewer(palette = "Purples",
                               name="Clade", 
                               direction = -1) +   
    ggplot2::scale_size(
        range = c(min(p$data$reference_percent, na.rm = TRUE)/100,
                  15),
        name=paste("1:1",reference_species,"orthologs (%)")) +
    ggplot2::guides(colour = ggplot2::guide_colourbar(title.position="top",
                                    direction = "vertical",
                                    override.aes = list(size = 0.5)),
           size = ggplot2::guide_legend(title.position="top",
                               direction = "vertical",
                               # override.aes = list(size = 0.5)
                               ),
           fill = ggplot2::guide_legend(title.position="top",  
                               direction = "vertical",
                               override.aes = list(size = 0.5))
    ) +  
    ggplot2::theme(panel.grid.minor.y = ggplot2::element_blank(), 
          panel.grid.major.y = ggplot2::element_blank(),
          panel.grid.major = ggplot2::element_line(color = "grey90"),
          plot.margin = ggplot2::margin(rep(1.5,4), unit = "cm"),
          legend.margin = ggplot2::margin(c(1.4, 0,0,0), unit = "cm"),
          legend.background = ggplot2::element_rect(fill = "transparent"),
          legend.position="bottom", 
          legend.box="horizontal")  
    return(p)
}
