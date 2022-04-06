common_species_names_dict <- function(species = NULL,
                                      type = c("scientific_name",
                                               "taxonomy_id"),
                                      verbose = TRUE) {
    #### return type ####
    type <- tolower(type[1]) 
    type_dict <- c("scientific_name"=1,
                   "taxonomy_id"=2) 
    type_select <- type_dict[[type]]
    #### dictionary ####
    dict <- list(
        "human" = c("Homo sapiens",9606),
        "humans" = c("Homo sapiens",9606),
        "chimp" = c("Pan troglodytes",9598),
        "chimps" = c("Pan troglodytes",9598),
        "chimpanzee" = c("Pan troglodytes",9598),
        "chimpanzees" = c("Pan troglodytes",9598),
        "monkey" = c("Macaca mulatta",9544),
        "monkeys" = c("Macaca mulatta",9544),
        "macaque" = c("Macaca mulatta",9544),
        "macaques" = c("Macaca mulatta",9544),
        "mouse" = c("Mus musculus",10090),
        "mice" = c("Mus musculus",10090),
        "rat" = c("Rattus norvegicus",10116),
        "rats" = c("Rattus norvegicus",10116),
        "hamster" = c("Mesocricetus auratus",10036),
        "golden hamster" = c("Mesocricetus auratus",10036),
        "syrian hamster" = c("Mesocricetus auratus",10036), 
        "cat" = c("Felis catus",9685),
        "cats" = c("Felis catus",9685), 
        "dog" = c("Canis lupus familiaris",9615),
        "dogs" = c("Canis lupus familiaris",9615), 
        "cow" = c("Bos taurus",9913),
        "cows" = c("Bos taurus",9913), 
        "chicken" = c("Gallus gallus",9031),
        "chickenw" = c("Gallus gallus",9031), 
        "zebrafish" = c("Danio rerio",7955),
        "frog" = c("Xenopus Silurana tropicalis",8364),
        "frogs" = c("Xenopus Silurana tropicalis",8364), 
        "fruit fly" = c("Drosophila melanogaster",7227),
        "fruit flies" = c("Drosophila melanogaster",7227), 
        "fly" = c("Drosophila melanogaster",7227),  
        "flies" = c("Drosophila melanogaster",7227),  
        "worm" = c("Caenorhabditis elegans",6239),
        "worms" = c("Caenorhabditis elegans",6239),
        "rice" = c("Oryza sativa",4530)
    )
    #### Return entire dict if NULL ####
    if (is.null(species)) {
        out <- unlist(lapply(dict, function(x)x[type_select] ))
        return(out)
    } 
    #### Standardise queries ####
    species <- tolower(species)
    #### If species is not in the dict, just return species ####
    if (all(!species %in% names(dict))) {
        return(species)
    }
    #### Only return species that are in the dict ####
    if (!any(species %in% names(dict))) {
        missing_species <- species[!(species %in% names(dict))] 
        # messager("WARNING: Species '",
        #     paste(missing_species, collapse = ", "),
        #     "' not found in taxa dict.",
        #     v = verbose
        # )
        species <- species[species %in% names(dict)]
    }
    messager("Common name mapping found for", species, v = verbose)
    out <- unlist(lapply(dict[species], function(x)x[type_select] ))
    return(out)
}