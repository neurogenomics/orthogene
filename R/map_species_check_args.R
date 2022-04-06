map_species_check_args <- function(orgs,
                                   output_format,
                                   search_cols){
    #### Ensure only one output_format ####
    output_format <- output_format[output_format %in% colnames(orgs)][1]
    if (all(length(output_format)==0 | is.na(output_format))) {
        cols <- paste0("   - '", colnames(orgs), "'", collapse = "\n")
        stop("output_format must be one of:\n", cols)
    }
    #### Ensure >0 search_cols ####
    search_cols <- search_cols[search_cols %in% colnames(orgs)]
    if (all(length(search_cols)==0)) {
        cols <- paste0("   - '", colnames(orgs), "'", collapse = "\n")
        stop("search_cols must be one of:\n", cols)
    }
    return(list(output_format=output_format,
                search_cols=search_cols))
}