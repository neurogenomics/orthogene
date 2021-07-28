#' Invert dictionary
#' 
#' Switch the names/items in a named list.
#' 
#' @return Named list
#' @importFrom stats setNames
#' @keywords internal
invert_dictionary <- function(dict){
  stats::setNames(names(dict), unname(dict))
}