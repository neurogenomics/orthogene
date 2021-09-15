check_species_babelgene <- function(source_id, 
                                    target_id){
    all_species <- babelgene::species()
    if(is_human(target_id)){
        if(!source_id %in% c(all_species$scientific_name,"Homo sapiens")){
            stop_msg <- paste0(
                source_id," not in available input_species when method='babelgene'.\n",
                "Try method= 'gprofiler' or 'homologene' instead."
            )
            stop(stop_msg)
        }
    }
    if(is_human(source_id)){
        if(!target_id %in% c(all_species$scientific_name,"Homo sapiens")){
            stop_msg <- paste0(
                source_id," not in available output_species when method='babelgene'.\n",
                "Try method= 'gprofiler' or 'homologene' instead."
            )
            stop(stop_msg)
        }
    } 
    if(all(!is_human(source_id),!is_human(target_id))){
        stop_msg <- paste0(
            "Either input_species or output_species must be 'human' when method='babelgene'.\n",
            "Try method= 'gprofiler' or 'homologene' instead."
        )
        stop(stop_msg)
    }
}