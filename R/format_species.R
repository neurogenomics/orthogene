#' Format species names
#' 
#' Format scientific species names into a standardised manner.
#' @param remove_parentheses Remove substring within parentheses: 
#' e.g. "Xenopus (Silurana) tropicalis" --> "Xenopus tropicalis"
#' @param abbrev Abbreviate all taxonomic levels except the last one:
#' e.g. "Canis lupus familiaris" ==> "C l familiaris" 
#' @param remove_subspecies Only keep the first two taxonomic levels:
#' e.g. "Canis lupus familiaris" --> "Canis lupus"
#' @param remove_subspecies_exceptions Selected species to ignore when 
#' \code{remove_subspecies=TRUE}.
#' e.g. "Canis lupus familiaris" --> "Canis lupus familiaris"
#' @param split_char Character to split species names by.
#' @param collapse Character to re-collapse species names with after splitting
#' with \code{split_char}.
#' @param remove_chars Characters to remove.
#' @param replace_char Character to replace \code{remove_chars} with.
#' @param lowercase Make species names all lowercase.
#' @param trim Characters to trim from the beginning/end of each species name.
#' @param standardise_scientific Automatically sets multiple arguments at once
#' to create standardised scientific names for each species. Assumes that 
#' \code{species} is provided in some version of scientific species names:
#' e.g. "Xenopus (Silurana) tropicalis" --> "Xenopus tropicalis"
#' @inheritParams map_species
#' @returns A named vector where the values are the standardised species names
#' and the names are the original input species names.
#' 
#' @export
#' @examples 
#' species <- c("Xenopus (Silurana) tropicalis","Canis lupus familiaris")
#' species2 <- format_species(species = species, abbrev=TRUE)
#' species3 <- format_species(species = species, 
#'                            standardise_scientific=TRUE,
#'                            remove_subspecies_exceptions=NULL)
format_species <- function(species,
                           remove_parentheses = TRUE,
                           abbrev = FALSE,
                           remove_subspecies = FALSE,
                           remove_subspecies_exceptions =  
                               c("Canis lupus familiaris"),
                           split_char = " ",
                           collapse = " ",
                           remove_chars = c(" ",".","(",")","[","]"),
                           replace_char = "",
                           lowercase = FALSE, 
                           trim = "'",
                           standardise_scientific = FALSE) {
    # devoptera::args2vars(format_species)
    
    #### Standardise scientific name ####
    if(isTRUE(standardise_scientific)){
        remove_subspecies <- TRUE
        lowercase <- TRUE 
        remove_chars <- c(".","(",")","[","]")
        replace_char <- ""
    }
    #### Prepare remove_chars ####
    rm_chars <-  paste0("[",
                        remove_chars,
                        "]", collapse = "|")    
    #### Store names ####
    nms <- if(is.null(names(species))) species else names(species)
    #### Enhance remove_subspecies_exceptions ####
    remove_subspecies_exceptions <- lapply(remove_subspecies_exceptions,
                                           FUN=function(s){
        c(remove_subspecies_exceptions,
          paste(strsplit(s,split_char)[[1]],collapse = " "),
          paste(strsplit(s,split_char)[[1]],collapse = "_"))
    }) |> unlist() |> unique()
    
    #### "Xenopus (Silurana) tropicalis" --> "Xenopus tropicalis" #### 
    if(isTRUE(remove_parentheses)){
        species <- mapply(species,FUN=function(s){
            gsub("[ ]+"," ",gsub("\\([^\\)]+\\)", "", s))    
        }) 
    } 
    #### "Schizosaccharomyces pombe 972h" --> "Schizosaccharomyces pombe" ####
    if(isTRUE(remove_subspecies)){
        species <- mapply(species,
                          FUN=function(s){ 
              if(tolower(s) %in% tolower(remove_subspecies_exceptions)){
                  return(s)
              } else { 
                  paste(utils::head(
                      strsplit(s,split_char)[[1]],2),
                      collapse = collapse)    
              }
          })
    }
    #### "Canis lupus familiaris" ==> "C l familiaris" ####
    if (isTRUE(abbrev)) {
        species <- lapply(unname(species), function(s){
                split <- strsplit(s, split = split_char)[[1]]
                if (length(split) > 1) {
                    subspecies <- tail(split, 1)
                    gs <- substr(split[seq(1, length(split)) - 1], 1, 1)
                    s <- paste(c(gs, subspecies), collapse = collapse) 
                } 
                return(s) 
            }) |> unlist() 
    }
    #### "C l familiaris" ==> "Clfamiliaris" ####
    if (rm_chars != FALSE) {
        species <- gsub(rm_chars, replace_char, unname(species))
        if (replace_char != "") {
            species <- trimws(species,
                whitespace = replace_char
            )
        }
    }
    #### "Clfamiliaris" ==> "clfamiliaris"
    if (isTRUE(lowercase)) {
        species <- tolower(species)
    } 
    if(!is.null(trim)){
        species <- trimws(species, whitespace = trim)
    }
    return(stats::setNames(species,nms))
}
