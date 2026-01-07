test_that("get_data_check works", {
  
    tmp_data <- "Bad credentials"
    tmp <- tempfile()
    writeLines(text = tmp_data, con = tmp)
    
    testthat::expect_error( 
        orthogene:::get_data_check(tmp)
    )
    
    
    tmp_data <- "Everything okey dokey"
    tmp <- tempfile()
    writeLines(text = tmp_data, con = tmp)
    
    testthat::expect_null( 
        orthogene:::get_data_check(tmp)
    )
})
