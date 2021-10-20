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
})
