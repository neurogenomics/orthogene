load_rds <- function(filename,
                     verbose = TRUE) {
    if (file.exists(filename)) {
        messager("Loading local .RDS file.", v = verbose)
        dat <- readRDS(filename)
    } else {
        messager("Loading remote .RDS file.", v = verbose)
        dat <- readRDS(url(filename, "rb"))
    }
    return(dat)
}
