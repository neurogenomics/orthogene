test_that("create_background works", {
    
    #### 1 ####
    bg <- orthogene::create_background(species1 = "mouse",
                                       species2 = "rat",
                                       output_species = "human")
    testthat::expect_gte(length(bg), 15000)
    #### 2 ####
    bg <- orthogene::create_background(species1 = "mouse",
                                       species2 = "rat",
                                       output_species = "rat")
    testthat::expect_gte(length(bg), 17000)
    #### 3 ####
    bg <- orthogene::create_background(species1 = "rat",
                                       species2 = "rat",
                                       output_species = "rat")
    testthat::expect_gte(length(bg), 20000)
    #### 4 ####
    bg <- orthogene::create_background(species1 = "human",
                                       species2 = "rat",
                                       output_species = "mouse")
    testthat::expect_gte(length(bg), 15000)
    #### 5 ####
    bg <- orthogene::create_background(species1 = "monkey",
                                       species2 = "chimp",
                                       output_species = "human")
    testthat::expect_gte(length(bg), 14000)

    #### use_intersect = FALSE → union path ####
    bg_union <- orthogene::create_background(
        species1 = "mouse",
        species2 = "rat",
        output_species = "human",
        use_intersect = FALSE
    )
    testthat::expect_gte(length(bg_union), 15000)
    ## Union should be at least as large as intersect
    bg_inter <- orthogene::create_background(
        species1 = "mouse",
        species2 = "rat",
        output_species = "human",
        use_intersect = TRUE
    )
    testthat::expect_gte(length(bg_union), length(bg_inter))

    #### user-supplied bg → short-circuit branch ####
    user_bg <- c("BRCA1","TP53","MYC","BRCA1")  # has duplicates
    bg_user <- orthogene::create_background(
        species1 = "mouse",
        species2 = "rat",
        output_species = "human",
        bg = user_bg
    )
    ## Function de-duplicates the user-supplied bg
    testthat::expect_setequal(bg_user, unique(user_bg))

    #### within-species fast path: species1 == species2 ####
    bg_same <- orthogene::create_background(
        species1 = "rat",
        species2 = "rat",
        output_species = "rat",
        as_output_species = TRUE
    )
    testthat::expect_gte(length(bg_same), 17000)
})
