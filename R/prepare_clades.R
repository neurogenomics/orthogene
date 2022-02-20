prepare_clades <- function(tree,
                           clades,
                           verbose = TRUE){
    requireNamespace("ggtree")
     
    if(!is.null(clades)){
        messager("Preparing data for",length(clades),"clades.",v=verbose)
        y <- dplyr::as_tibble(tree)
        nodes <- lapply(names(clades), function(cl){
            species_list <- clades[[cl]][clades[[cl]] %in% tree$tip.label]
            if(length(species_list)<1) {
                messager(
                    "Warning: Each clade in `clades` must contain a vector",
                     "of at least 1 species. Omitting clade:",cl,
                    v=verbose)
                return(NULL)
            } else {
                data.frame(node=ggtree::MRCA(y, species_list)$node,
                           name=cl)
            } 
        }) %>% data.table::rbindlist()
        return(nodes)
    } else { 
        return(NULL)
    }
}
