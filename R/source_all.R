source_all <- function (path = "R/",
                        pattern = "*.R$",
                        packages = "dplyr") {
    for (x in packages) {
        library(x, character.only = TRUE)
    }
    file.sources = list.files(path = path, pattern = pattern, 
                              full.names = TRUE, ignore.case = TRUE)
    message("Sourcing ", length(file.sources), " files.")
    out <- lapply(file.sources, source)
}