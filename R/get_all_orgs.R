get_all_orgs <- function(method = "gprofiler",
                         use_local = TRUE, 
                         verbose = TRUE){
    taxon_id <- NULL;
    
    if(method %in% methods_opts(gprofiler_opts = TRUE)){
        messager("Retrieving all organisms available in",
                 paste0(method,"."),v=verbose)
        orgs <- get_orgdb_gprofiler(
            use_local = use_local,
            verbose = verbose
        )
        orgs$source <- "gprofiler"
    } else if(method %in% methods_opts(homologene_opts = TRUE)){
        messager("Retrieving all organisms available in",
                 paste0(method,"."),v=verbose)
        orgs <- taxa_id_dict(species = NULL, 
                             include_common_names = FALSE)
        orgs <- orgs[!duplicated(unname(orgs))] 
        orgs <- data.frame(scientific_name=names(orgs),
                           taxonomy_id=unname(orgs), 
                           source = "homologene",
                           check.rows = FALSE, 
                           check.names = FALSE)
    } else if(method %in% methods_opts(babelgene_opts = TRUE)){
        messager("Retrieving all organisms available in",
                 paste0(method,"."),v=verbose)
        requireNamespace("babelgene")
        orgs <- babelgene::species() %>% 
            dplyr::rename(taxonomy_id=taxon_id)
    } else if (tolower(method) == "genomeinfodb") {
        #### Load a really big organism reference ####
        orgs <- rbind(orgs, get_orgdb_genomeinfodbdata(verbose = verbose))
        orgs$source <- "genomeinfodb"
    } else {
        messager(paste0("method='",method,"'"),
                 "not recognized by get_all_orgs.",
                 "Defaulting to 'gprofiler'.")
        orgs <- get_orgdb_gprofiler(
            use_local = use_local,
            verbose = verbose
        )
        orgs$source <- "gprofiler"
    }
    return(orgs)
}
