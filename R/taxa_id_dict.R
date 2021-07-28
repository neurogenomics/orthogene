#' Taxa ID dictionary
#' 
#' Dictionary of NCBI taxonomy IDs mapped to 
#' Latin and common names of 20+ organisms. 
#' 
#' @param species Species to get dictionary for. 
#' Can supply either Latin names (e.g. "Homo sapiens") or 
#' common names (e.g, "human").
#' 
#' @return Named list of taxa IDs to organism names.
#' @export 
#' @examples 
#' dict <- taxa_id_dict()
#' full_dict <- taxa_id_dict(species=NULL) 
#' print(full_dict[c("chimp","mouse")])
taxa_id_dict <- function(species=c("human","chimp","monkey","mouse","rat",
                                   "dog","cow","chicken",
                                   "zebrafish","frog","fly","worm",
                                   "rice")){ 
  dict <- setNames(homologene::taxData$tax_id,
                   homologene::taxData$name_txt)
  ## Add some common names for ease of use
  dict <- c(dict,
            "human"=9606,
            "chimp"=9598,
            "chimpanzee"=9598,
            "monkey"=9544,
            "macaque"=9544,
            "mouse"=10090,
            "rat"=10116,
            "dog"=9615,
            "cow"=9913,
            "chicken"=9031,
            "zebrafish"=7955,
            "frog"=8364,
            "fly"=7227,
            "worm"=6239,
            "rice"=4530)
  if(is.null(species)) return(dict) else  species <- tolower(species)
   
  if(!any(species %in% names(dict))){
    missing_species <- species[!(species %in% names(dict))]
    messager("::WARNING:: Species '",paste(missing_species,collapse=", "),
            "' not found in taxa dict.") 
    species <-  species[species %in% names(dict)]
  }
  return(dict[species])
}