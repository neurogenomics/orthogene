methods_opts <- function(method = NULL,
                         homologene_opts = FALSE,
                         gprofiler_opts = FALSE,
                         babelgene_opts = FALSE) {
    opts <- c()
    #### Check homologene_opts ####
    if (homologene_opts) {
        homol_opts <- c("homologene", "h")
        opts <- c(opts, homol_opts)
    }
    #### Check gprofiler_opts ####
    if (gprofiler_opts) {
        gprof_opts <- c("gorth", "gprofiler2", "gprofiler", "g")
        opts <- c(opts, gprof_opts)
    }
    #### Check babelgene ####
    if (babelgene_opts) {
        babel_opts <- c("babelgene", "babel", "b")
        opts <- c(opts, babel_opts)
    }
    #### Query ####
    if (is.null(method)) {
        return(opts)
    } else {
        #### Standardise method ####
        method <- tolower(gsub(" ", "", method[1]))
        return(method %in% opts)
    }
}
