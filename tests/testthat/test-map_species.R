test_that("map_species works", {
    species_sn <- map_species(
        species = c("human", 9544, "mus musculus", "fruit fly", "Celegans"),
        output_format = "scientific_name"
    )
    species_id <- map_species(
        species = c("human", 9544, "mus musculus", "fruit fly", "Celegans"),
        output_format = "id"
    )
    species_tid <- map_species(
        species = c("human", 9544, "mus musculus", "fruit fly", "Celegans"),
        output_format = "taxonomy_id"
    )
    testthat::expect_equal(sum(sapply(species_sn, is.null)), 0)
    testthat::expect_equal(sum(sapply(species_id, is.null)), 0)
    testthat::expect_equal(sum(sapply(species_tid, is.null)), 0)
    testthat::expect_error(map_species(
        species = c("human"),
        output_format = "taxonomy_idTYPO"
    ))
})
