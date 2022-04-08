test_that("sparsity works", {
  
    data("exp_mouse")
    sp <- orthogene:::sparsity(X = exp_mouse)
    testthat::expect_equal(round(sp,3), .054)
})
