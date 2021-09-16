common_species_names_dict <- function(species = NULL,
                                      verbose = TRUE) {
    dict <- c(
        "human" = 9606,
        "humans" = 9606,
        "chimp" = 9598,
        "chimps" = 9598,
        "chimpanzee" = 9598,
        "chimpanzees" = 9598,
        "monkey" = 9544,
        "monkeys" = 9544,
        "macaque" = 9544,
        "macaques" = 9544,
        "mouse" = 10090,
        "mice" = 10090,
        "rat" = 10116,
        "hamster" = 10036,
        "golden hamster" = 10036,
        "syrian hamster" = 10036,
        "rats" = 10116,
        "dog" = 9615,
        "dogs" = 9615,
        "cow" = 9913,
        "cows" = 9913,
        "chicken" = 9031,
        "chickens" = 9031,
        "zebrafish" = 7955,
        "frog" = 8364,
        "frogs" = 8364,
        "fruit fly" = 7227,
        "fruit flies" = 7227,
        "fly" = 7227,
        "flies" = 7227,
        "worm" = 6239,
        "worms" = 6239,
        "rice" = 4530
    )
    #### Return entire dict if NULL ####
    if (is.null(species)) {
        return(dict)
    } else {
        species <- tolower(species)
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
        messager("WARNING: Species '",
            paste(missing_species, collapse = ", "),
            "' not found in taxa dict.",
            v = verbose
        )
        species <- species[species %in% names(dict)]
    }
    messager("Common name mapping found for", species, v = verbose)
    return(dict[species])
}
