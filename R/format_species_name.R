format_species_name <- function(species,
                                gs_s=FALSE, 
                                remove_chars=" |[.]|[-]",
                                lowercase=FALSE){ 
  #### "Canis lupus familiaris" ==> "C l familiaris" ####
  if(gs_s){
    split <- strsplit(unname(species),split = " ")[[1]]
    if(length(split)>1){
      subspecies <- tail(split,1)
      gs <- substr(split[seq(1,length(split))-1], 1, 1) 
      species <- paste(c(gs,subspecies), collapse = " ")
    }
  }
  #### "C l familiaris" ==> "Clfamiliaris" ####
  if(remove_chars!=FALSE){
    species <- gsub(" |[.]|[-]","",unname(species))
  }
  #### "Clfamiliaris" ==> "clfamiliaris"
  if(lowercase){
    species <- tolower(species)
  }
  return(species)
}