plot_orthotree_metadata <- function(orth_report,
                                    uids,
                                    tr,
                                    verbose=TRUE){
    target_species <- input_species <- NULL;
    #### Defin uppercase function ####
    firstup <- function(x) {
        mapply(x, FUN=function(x){
            substr(x, 1, 1) <- toupper(substr(x, 1, 1))
            x
        })
    }
    #### Merge metadata ####
    if(!is.null(orth_report)){
        d <- merge(uids, 
                   orth_report |> 
                       dplyr::rename(species = target_species,
                                     input_species_original=input_species),
                   all = TRUE,
                   by = "species")
    } else {
        d <- uids
    }
    d <- d |> dplyr::relocate(species, .after = dplyr::last_col())
    #### IMPORTANT! #####
    ## The first column MUST be the same label as the tree's tip.label 
    d <- cbind(tip.label=tr$tip.map[d$input_species], 
               d)
    d$tip.label_formatted <- firstup(d$tip.label) 
    #### Format for title case #### 
    messager(nrow(d),"species remaining after metadata preparation.",
             v=verbose)
    return(d)
}