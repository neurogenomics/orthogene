find_all_nas <- function(v) {
    (is.na(unname(v))) |
        (is.nan(unname(v))) |
        (as.character(unname(v)) == "NA_character_") |
        (as.character(unname(v)) == "nan") |
        (tolower(as.character(unname(v))) == "na") |
        (tolower(as.character(unname(v))) == "n/a")
}
