load_data <- function(filename,
                      verbose = TRUE) {
    if (endsWith(tolower(filename), ".rds")) {
        dat <- load_rds(
            filename = filename,
            verbose = verbose
        )
    } else {
        dat <- load_rda(
            filename = filename,
            verbose = verbose
        )
    }
    return(dat)
}
