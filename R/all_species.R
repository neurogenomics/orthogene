#' All species
#'
#' List all species currently supported by \pkg{orthogene}.
#' Wrapper function for \link[orthogene]{map_species}.
#' When \code{method=NULL}, all species from all available 
#' methods will be returned.
#' 
#' @param verbose Print messages.
#' @inheritParams convert_orthologs
#' @inheritParams map_species
#' @return \link[data.table]{data.table} of species names, 
#' provided in multiple formats.
#'
#' @export
#' @importFrom data.table rbindlist
#' @importFrom stats setNames 
#' @examples
#' species_dt <- all_species()
all_species <- function(method = NULL,
                        verbose = TRUE) {
    if(is.null(method)){
        method <- eval(formals(map_species)$method)
    }
    species_dt <- lapply(stats::setNames(method,
                                         method), function(m){
        map_species(
            species = NULL,
            method = m,
            verbose = verbose
        )
    }) |> data.table::rbindlist(fill = TRUE, 
                                use.names = TRUE, 
                                idcol = "method")
    return(species_dt)
}
