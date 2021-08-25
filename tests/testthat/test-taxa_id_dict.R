test_that("multiplication works", {
    testthat::expect_gte(length(taxa_id_dict()), 12)
    testthat::expect_equal(length(taxa_id_dict(species = c("cow", "monkey"))), 2)
    testthat::expect_equal(length(taxa_id_dict(species = c("cow", "monkeyTYPO"))), 1)
})
