test_that("taxa_id_dict works", {
    
    testthat::expect_gte(length(orthogene::: taxa_id_dict()), 12)
    testthat::expect_equal(length(orthogene:::taxa_id_dict(species = c("cow", "monkey"))), 2)
    testthat::expect_equal(length(orthogene:::taxa_id_dict(species = c("cow", "monkeyTYPO"))), 1)
})
