test_that("check_species_babelgene errors when human-pair invariants violated", {

    ## Valid: mouse -> human (source non-human, target human)
    testthat::expect_silent(
        orthogene:::check_species_babelgene(
            source_id = "Mus musculus",
            target_id = "Homo sapiens"
        )
    )
    ## Valid: human -> mouse
    testthat::expect_silent(
        orthogene:::check_species_babelgene(
            source_id = "Homo sapiens",
            target_id = "Mus musculus"
        )
    )

    ## target = human but source not in babelgene's species table
    testthat::expect_error(
        orthogene:::check_species_babelgene(
            source_id = "Pan paniscus_TYPO",
            target_id = "Homo sapiens"
        ),
        regexp = "not in available input_species"
    )

    ## source = human but target not in babelgene's species table
    testthat::expect_error(
        orthogene:::check_species_babelgene(
            source_id = "Homo sapiens",
            target_id = "Mus musculus_TYPO"
        ),
        regexp = "not in available output_species"
    )

    ## Neither side is human (babelgene only does {non-human <-> human} pairs)
    testthat::expect_error(
        orthogene:::check_species_babelgene(
            source_id = "Mus musculus",
            target_id = "Rattus norvegicus"
        ),
        regexp = "input_species or output_species must be"
    )
})
