test_that("taxa_id_dict works", {
  dict <- taxa_id_dict()
  full_dict <- taxa_id_dict(species=NULL)
  sub_dict <- full_dict[c("chimp","mouse")]
  testthat::expect_gte(length(dict), 13)
  testthat::expect_gte(length(full_dict), 36)
  testthat::expect_equal(length(sub_dict), 2)
})
