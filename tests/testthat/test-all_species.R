test_that("all_species works", {
  
    species_dt <- all_species()
    testthat::expect_gte(nrow(species_dt), 700)
    
    if(is_gha()){
        species_dt <- all_species(method="genomeinfodb")
        testthat::expect_gte(nrow(species_dt), 2e6) # over 2.5 million species!
    }
})
