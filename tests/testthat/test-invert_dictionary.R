test_that("invert_dictionary works", {
    dict <- taxa_id_dict()
    dict_inv <- invert_dictionary(dict)

    name_check <- sum(names(dict_inv) %in% unname(dict)) / length(dict)
    item_check <- sum(unname(dict_inv) %in% names(dict)) / length(dict)
    testthat::expect_equal(name_check, 1)
    testthat::expect_equal(item_check, 1)
})
