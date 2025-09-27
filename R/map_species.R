#' Standardise species names
#'
#' Search \code{gprofiler} database for species
#' that match the input text string.
#' Then translate to a standardised species ID.
#'
#' @param species Species query
#' (e.g. "human", "homo sapiens", "hsapiens", or 9606).
#' If given a list, will iterate queries for each item.
#' Set to \code{NULL} to return all species.
#' @param search_cols Which columns to search for
#' \code{species} substring in
#' metadata \href{https://biit.cs.ut.ee/gprofiler/api/util/organisms_list}{
#' API}.
#' @param output_format Which column to return.
#' @param use_local If \code{TRUE} \emph{default},
#' \link[orthogene]{map_species}
#' uses a locally stored version of the species metadata table
#' instead of pulling directly from the gprofiler API.
#' Local version may not be fully up to date,
#' but should suffice for most use cases.
#' @param verbose Print messages.
#' @inheritParams convert_orthologs
#' @inheritParams format_species
#'
#' @return Species ID of type \code{output_format}
#' @export
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr arrange filter_at any_vars
#' @examples
#' ids <- map_species(species = c(
#'     "human", 9606, "mus musculus",
#'     "fly", "C elegans"
#' ))
map_species <- function(species = NULL,
                        search_cols = c(
                            "display_name",
                            "id",
                            "scientific_name",
                            "taxonomy_id"
                        ),
                        output_format = c(
                            "scientific_name",
                            "id",
                            "display_name",
                            "taxonomy_id",
                            "version",
                            "scientific_name_formatted"
                        ),
                        method = c( 
                            "homologene",
                            "gprofiler",
                            "babelgene"
                        ),
                        remove_subspecies = TRUE,
                        remove_subspecies_exceptions = 
                            c("Canis lupus familiaris"),
                        use_local = TRUE, 
                        verbose = TRUE) { 
    . <- NULL;

    #### Load organism reference ####
    method <- tolower(method)[1]
    orgs <- get_all_orgs(method = method, 
                         use_local = use_local, 
                         verbose = verbose) 
    #### Return all species as an option ####
    if (is.null(species)) {
        messager("Returning table with all species.", v = verbose)
        return(orgs)
    }
    #### Prepare species names #####
    species <- base::trimws(base::trimws(species),whitespace = "'")
    #### Check args ####
    msca_out <- map_species_check_args(orgs = orgs, 
                                       output_format = output_format,
                                       search_cols = search_cols)
    output_format <- msca_out$output_format
    search_cols <- msca_out$search_cols
    ### Iterate over multiple queries ####
    species_results <- lapply(stats::setNames(species,
                                              species), 
                              function(spec) {
        messager("Mapping species name:", spec, v = verbose)
        #### Map common species names ####
        spec <- common_species_names_dict(
            species = spec,
            verbose = verbose
        )
        #### Query multiple columns ####
        if (is.character(spec)) {
            mod_spec <- format_species(species = spec, 
                                            abbrev = TRUE)
            mod_spec2 <- format_species(
                species = spec)
            mod_spec2 <- gsub("_"," ",mod_spec2)
            spec_queries <- paste(unname(spec), mod_spec, mod_spec2, sep = "|")
        } else {
            spec_queries <- spec
        } 
        orgs_sub <- orgs |>
            dplyr::filter_at(
                .vars = search_cols,
                .vars_predicate = dplyr::any_vars(
                    grepl(spec_queries, ., ignore.case = TRUE)
                )
            )
        if (nrow(orgs_sub) > 0) {
            if (nrow(orgs_sub) > 1) {
                messager(nrow(orgs_sub),
                    "organisms identified from search.\nSelecting first:\n",
                    paste("  -", orgs_sub[[output_format]], collapse = "\n "),
                    v = verbose
                )
                orgs_sub <- orgs_sub[1, ]
            } else {
                messager(nrow(orgs_sub), "organism identified from search:",
                    orgs_sub[[output_format]],
                    v = verbose
                )
                orgs_sub <- orgs_sub[1, ]
            }
            return(orgs_sub[[output_format]])
        } else {
            messager("WARNING: No organisms identified matched ",
                paste0("'", spec, "'"),
                "Try a different query.",
                v = verbose
            )
            return(NULL)
        }
    }) 
    if(output_format=="scientific_name_formatted"){
        species_results <- format_species(
            species = species_results, 
            remove_subspecies = remove_subspecies,
            remove_subspecies_exceptions = remove_subspecies_exceptions,
            standardise_scientific = TRUE)
    }
    return(unlist(species_results))
}
