test_that("prepare_tree works", {
  
    species <- c("human","chimp","mouse")
    tr <- orthogene::prepare_tree(species = species)
    testthat::expect_true(methods::is(tr,"phylo"))
    testthat::expect_length(tr$node.label,2)
    testthat::expect_length(tr$tip.label,3)
})
