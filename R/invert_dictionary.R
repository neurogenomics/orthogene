invert_dictionary <- function(dict){
  setNames(names(dict), unname(dict))
}