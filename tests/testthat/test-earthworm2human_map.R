test_that("earthworm2human_map works", {
  
    map <- orthogene:::earthworm2human_map()
    testthat::expect_gte(nrow(map), 4.6e5)
    testthat::expect_true(all(grepl("^evm",map$qseqid)))
})
