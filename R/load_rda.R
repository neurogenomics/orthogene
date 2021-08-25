load_rda <- function(filename,
                     verbose = TRUE) {
    load_rdata <- function(filename) {
        load(filename)
        return(get(ls()[ls() != "filename"]))
    }
    source_rdata <- function(filename) {
        repmis::source_data(filename)
        get(ls()[ls() != "filename"])
    }


    if (file.exists(filename)) {
        messager("Loading local .RDA file.", v = verbose)
        dat <- load_rdata(filename)
    } else {
        messager("Loading remote .RDA file.", v = verbose)
        dat <- source_rdata(filename)
    }
    return(dat)
}
