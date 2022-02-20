format_species_name <- function(species,
                                gs_s = FALSE,
                                split_char = " ",
                                remove_chars = " |[.]|[-]|[(]|[)]",
                                replace_char = "",
                                lowercase = FALSE) {
    #### "Canis lupus familiaris" ==> "C l familiaris" ####
    if (gs_s) {
        species <- lapply(unname(species), function(s){
                split <- strsplit(s, split = split_char)[[1]]
                if (length(split) > 1) {
                    subspecies <- tail(split, 1)
                    gs <- substr(split[seq(1, length(split)) - 1], 1, 1)
                    s <- paste(c(gs, subspecies), collapse = " ") 
                } 
                return(s) 
            }) %>% unlist() 
    }
    #### "C l familiaris" ==> "Clfamiliaris" ####
    if (remove_chars != FALSE) {
        species <- gsub(remove_chars, replace_char, unname(species))
        if (replace_char != "") {
            species <- trimws(species,
                whitespace = replace_char
            )
        }
    }
    #### "Clfamiliaris" ==> "clfamiliaris"
    if (lowercase) {
        species <- tolower(species)
    }
    return(species)
}
