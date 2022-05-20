gconvert_target_opts <- function(target,
                                 species="human",
                                 types=c("Numeric","Non-numeric")){
    species_short <- type <- NULL;
    target <- toupper(target)[1]
    ns_all <- gprofiler_namespace
    ### Only run check for species I've added so far ####
    if(species %in% unique(ns_all$species_short)){
        ns_type <- subset(ns_all, type %in% types)
        species_nm <- species ## Avoid confusing data.table
        ns <- ns_type[species_short==species_nm,]
        if(!target %in% ns$target){
            stp <- paste("When species='human', target must be one of:",
                         paste("\n-",paste0("'",sort(ns_type$target),"'"),
                               collapse = ""))
            stop(stp)
        }  
    } 
    return(target)
}
