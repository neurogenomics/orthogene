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
#' @keywords internal
#' @importFrom ggtree %<+% 
ggtree_plot <- function(tr,
                        d,
                        scaling_factor = 1,
                        clades = NULL,
                        clades_palette = NULL,
                        reference_species = NULL, 
                        verbose = TRUE){
    requireNamespace("ggtree")
    requireNamespace("ggplot2")  
    
    one2one_orthologs <- node <- name <- picid <-
        label <- target_percent <- NULL;
    
    #### Create palette ####
    if(is.null(clades_palette)){
        requireNamespace("RColorBrewer") 
        clades_palette <- RColorBrewer::brewer.pal(n = nrow(clades),
                                                   name = "Purples")
        names(clades_palette) <- rev(clades$name)
    }
    messager("Creating ggtree plot.",v=verbose)
    x <- scaling_factor #300
    p <- ggtree::ggtree(tr,
                size = 1, 
                layout = "circular",
                # mrsd = "2020-01-01",
                ggplot2::aes(color=one2one_orthologs),
                continuous = 'colour') %<+% d 
    if(!is.null(clades)){
        p <- p +  ggtree::geom_hilight(data=clades, 
                                       ggplot2::aes(node=node, fill=name))
    }
    p <- p + 
        ggtree::geom_tiplab2(ggplot2::aes(image=picid),
                 geom="phylopic", 
                 offset=.7*x, alpha=.9, angle=0, size=.1) + 
        #### Specices name ####
        ggtree::geom_tiplab2(ggplot2::aes(label=gsub("_"," ",label)), 
                 geom = "label",
                 offset = .3*x,
                 vjust = -.5, 
                 color="grey20",
                 angle = 0,
                 align = TRUE,
                 alpha = .5) +      
        #### % orthologs label ####
    ggtree::geom_tiplab2(
        ggplot2::aes(label=paste0(round(target_percent,1),"%")), 
                 geom = "label",
                 offset = .3*x,
                 vjust = .5, 
                 color="grey60",
                 angle = 0,
                 align = TRUE,
                 alpha = .5) + 
    ggtree::geom_nodepoint(color="white", alpha=.6, size=3) + 
        # geom_nodelab(angle=0, geom = "label") + 
        #### Large filled circle ####
    ggtree::geom_tippoint(ggplot2::aes(size=target_percent), alpha=.75) +
        #### Large unfilled circle ####
    ggtree::geom_tippoint(shape=1, alpha=1, 
                          show.legend = FALSE, size=15.5) +
        #### Small dark dots ####
    ggtree::geom_tippoint(ggplot2::aes(size=1.2), alpha=.6,
                          show.legend = FALSE, color=1) + 
    ggplot2::scale_color_viridis_c(
        name=paste("1:1",reference_species,"orthologs (count)")) +
    ggplot2::scale_fill_manual(values=clades_palette, name="Clade") +   
    ggplot2::scale_size(
        range = c(-10,15), 
        name=paste("1:1",reference_species,"orthologs (%)")) +
    ggplot2::guides(colour = ggplot2::guide_colourbar(title.position="top",
                                    direction = "vertical",
                                    override.aes = list(size = 0.5)),
           size = ggplot2::guide_legend(title.position="top",
                               direction = "vertical",
                               override.aes = list(size = 0.5)),
           fill = ggplot2::guide_legend(title.position="top",  
                               direction = "vertical",
                               override.aes = list(size = 0.5))
    ) + 
    # theme_minimal() +
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
