prepare_clades <- function(tree,
                           clades,
                           verbose = TRUE){
    requireNamespace("ggtree")
    label <- name <- NULL;
     
    if(!is.null(clades)){
        if(is.data.frame(clades)) return(clades)
        messager("Preparing data for",length(clades),"clades.",v=verbose)
        y <- dplyr::as_tibble(tree)
        nodes <- lapply(names(clades), function(cl){
            species <- format_species(species = clades[[cl]], 
                                           standardise_scientific = TRUE)
            species_list <- species[species %in% tree$tip.label]
            if(length(species_list)<1) {
                messager(
                    "Warning: Each clade in `clades` must contain a vector",
                     "of at least 1 species. Omitting clade:",cl,
                    v=verbose)
                return(NULL)
            } else {
                data.frame(ggtree::MRCA(y, species_list),
                           name=cl)
            } 
        }) |> data.table::rbindlist()
        nodes[,label:=as.numeric(label)]
        nodes[,name:=factor(name,unique(name),ordered = TRUE)]
        return(nodes)
    } else { 
        return(NULL)
    }
}
