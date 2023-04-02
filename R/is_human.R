is_human <- function(species) {
    tolower(species) %in% c(
        "hsapiens", "human",
        "h sapiens", "homo sapiens","homo sapiens sapiens",
        9606
    )
}
